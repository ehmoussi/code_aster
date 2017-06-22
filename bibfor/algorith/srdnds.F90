! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine srdnds(nmat,materf,i1,devsig,bprimp,nvi,vint,val,para,tmp,dndsig)

!

!!!
!!! MODELE LKR : CALCUL DE DERIVEE DE N PAR RAPPORT A SIGMA
!!!

! ===================================================================================
! IN  : NMAT           : DIMENSION TABLE DES PARAMETRES MATERIAU
!     : MATERF(NMAT,2) : PARAMETRES MATERIAU A T+DT
!     : DEVSIG(6)      : DEVIATEUR DES CONTRAINTES
!     : I1             : TRACE DES CONTRAINTES
!     : BPRIMP         : PARAMETRE DE DILATANCE FCTN SIGMA
!     : NVI            : NOMBRE DE VARIABLES INTERNES
!     : VINT(NVI)      : VARIABLES INTERNES
!     : VAL            : BOOLEEN PRECISANT DILATANCE EN PRE(0) OU POST-PIC(1)
!     : PARA(3)        : VECTEUR CONTENANT AXI, SXI ET MXI
! OUT : DNDISG(6,6)    :  DERIVEE DE N PAR RAPPORT A SIGMA (NDT X NDT)
! ===================================================================================
    
    implicit   none

#include "asterfort/lcdima.h"
#include "asterfort/lcinma.h"
#include "asterfort/lcinve.h"
#include "asterfort/lcprmv.h"
#include "asterfort/lcprsc.h"
#include "asterfort/lcprsm.h"
#include "asterfort/lcprsv.h"
#include "asterfort/lcprte.h"
#include "asterfort/srdbds.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nmat,nvi,val
    real(kind=8) :: materf(nmat,2),dndsig(6,6),devsig(6),i1
    real(kind=8) :: bprimp,vint(nvi),para(3),tmp
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: ndt, ndi,i,j
    
    real(kind=8) :: dsdsig(6,6),di1dsi(6),sii
    real(kind=8) :: dbetds(6),dbetdi,mident(6,6)
    real(kind=8) :: dsiids(6,6),kron2(6,6)
    real(kind=8) :: unstro,unssii,kron(6),dbdsig(6)
    real(kind=8) :: devbds(6,6),dsidsi(6,6),sdsids(6,6),didbds(6,6)
    
    common /tdim/ ndt,ndi
    
    !!!
    !!! 1) Calcul des termes communs
    !!!
    
    !!! Construction de sii
    call lcprsc(devsig,devsig,sii)
    sii=sqrt(sii)
    
    !!! Construction de kronecker
    call lcinve(0.d0,kron)
    do i=1,ndi
        kron(i)=1.d0
    end do
    
    !!! Construction de la matrice identite
    call lcinma(0.d0,mident)
    
    do i=1,ndt
        mident(i,i)=1.d0
    end do
    
    !!! Construction de d(i1)/d(sigma)
    call lcinve(0.d0,di1dsi)
    
    do i=1,ndi
        di1dsi(i)=1.d0
    end do
    
    !!! Construction de d(s)/d(sigma)
    unstro=1.d0/3.d0
    call lcprte(kron,kron,kron2)
    call lcprsm(unstro,kron2,kron2)
    call lcdima(mident,kron2,dsdsig)
    
    !!! Construction de d(sii)/d(s)
    unssii=1.d0/sii
    call lcprsv(unssii,devsig,dsiids)
    
    !!! Calcul de d(beta')/d(s) et d(beta')/d(i1)
    call srdbds(nmat,materf,i1,devsig,nvi,vint,para,val,tmp,dbetds,dbetdi)
    
    !!! Construction de d(beta')/d(sigma)
    do i=1, ndt
    
        dbdsig(i)=0.d0
        
        do j=1,ndt
            dbdsig(i)=dbdsig(i)+dbetds(j)*dsdsig(j,i)
        end do
        
        dbdsig(i)=dbdsig(i)+dbetdi*di1dsi(i)
        
    end do
    
    !!! Produit tensoriel s x d(beta')/d(sigma)
    call lcprte(devsig, dbdsig, devbds)
    
    !!! s x d(sii)/d(sigma)
    call lcprmv(dsdsig, dsiids, dsidsi)
    call lcprte(devsig, dsidsi, sdsids)
    
    !!! kron x d(beta')/d(sigma)
    call lcprte(kron, dbdsig, didbds)
    
    !!!
    !!! 2) Assemblage
    !!!
    
    do i=1,ndt
        do j=1,ndt
            dndsig(i,j)=((devbds(i,j)/sii+bprimp/sii*dsdsig(i,j)-&
                        bprimp/sii**2.d0*sdsids(i,j))*sqrt(bprimp**2+3.d0)-&
                        bprimp/sqrt(bprimp**2.d0+3.d0)*&
                        (bprimp/sii*devbds(i,j)-didbds(i,j)))/(bprimp**2+3.d0)
        end do
    end do

end subroutine
