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

subroutine srdvds(dt, nbmat, mater, gv, dfdsv, seuilv, dvds)

!

!!!
!!! MODELE LKR : DERIVEE DE L AMPLITUDE DES DEFORMATIONS IRREVERSIBLES / DEPS
!!!

! ===================================================================================
! IN  : DT     : PAS DE TEMPS
!     : NBMAT  : NOMBRE DE PARAMETRES MATERIAU
!     : MATER  : COEFFICIENTS MATERIAU A T + DT
!                   MATER(*,1) = CARACTERISTIQUES ELASTIQUES
!                   MATER(*,2) = CARACTERISTIQUES PLASTIQUES
!     : GVP    : GV = DFVP/DSIG-(DFVP/DSIG*N)*N
!     : DFDSV  : DERIVEE DU CRITERE VISCOPLASTIQUE PAR RAPPORT A LA CONTRAINTE
!     : SEUILV : SEUIL VISCOPLASTIQUE
! OUT : DVDS   : DERIVEE DE DEPSV/ DSIG
! ===================================================================================
    
    implicit    none

#include "asterfort/lcprte.h"
#include "asterfort/r8inir.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat
    real(kind=8) :: mater(nbmat,2), dvds(6,6), dt
    real(kind=8) :: gv(6), dfdsv(6), seuilv
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: i, k, ndi, ndt
    real(kind=8) :: pa, aa(6,6), a, n, a0, z, r, tpp, trr
    common /tdim/   ndt , ndi
    
    !!!
    !!! Recuperation des temperatures
    !!!
    
    tpp=mater(7,1)
    trr=mater(8,1)
    
    !!!
    !!! Para. du modele
    !!!
    
    !!! a T0
    pa=mater(1,2)
    a0=mater(16,2)
    n=mater(17,2)
    z=mater(27,2)
    r=8.3144621d0
    
    !!! a T
    if ((tpp.ge.trr).and.(trr.gt.0.d0)) then
        a=a0*exp(-z/r/tpp*(1.d0-tpp/trr))
    else
        a=a0
    endif
    
    !!!
    !!! Matrice intermediaire
    !!!
    
    call r8inir(6*6, 0.d0, aa, 1)
    call lcprte(dfdsv, gv, aa)
    
    !!!
    !!! Calcul de dphi/ddeps
    !!!
    
    do i=1, ndt
        do k=1, ndt
            if (seuilv.le.0.d0) then
                dvds(i,k)=0.d0
            else
                dvds(i,k)=a*n/pa*(seuilv/pa)**(n-1.d0)*aa(i,k)*dt
            endif
        end do
    end do

end subroutine
