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

subroutine srdfds(nbmat,mater,para,var,ds2hds,ucri,dfdsig)

!

!!!
!!! MODELE LKR : CALCUL DE DF/DSIG
!!!

! ===================================================================================
! IN  : NBMAT          : NOMBRE DE PARAMETRES DU MODELE
!     : MATER(NBMAT,2) : PARAMETRES DU MODELE
!     : S(6)           : TENSEUR DU DEVIATEUR DES CONTRAINTES
!     : PARA(3)        : VARIABLE D'ECROUISSAGE
!                           PARA(1) = AXI
!                           PARA(2) = SXI
!                           PARA(3) = MXI
!     : VAR(4)         : (ADXI, BDXI, DDXI, KDXI)
!     : DS2HDS(6)      : D(SII*H(THETA))/DSIG
!     : UCRI           : TERME SOUS LA PUISSANCE DANS LE CRITERE
! OUT : DFDSIG(6)      : DF/DSIG
! ===================================================================================

    implicit      none

#include "asterc/r8prem.h"
#include "asterfort/r8inir.h"
#include "asterc/r8pi.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat
    real(kind=8) :: mater(nbmat,2),para(3),var(4),ucri,ds2hds(6),dfdsig(6)
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: ndi,ndt,i
    real(kind=8) :: sigc,gamma,beta,r0c,pi,fact1
    real(kind=8) :: a(6),kron(6),fact3
    common /tdim/ ndt, ndi
    
    data kron /1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
    
    !!!
    !!! Recuperation de parametres du modele
    !!!
    
    sigc=mater(3,2)
    beta=mater(4,2)
    gamma=mater(5,2)
    pi=r8pi()
    r0c=cos(beta*pi/6.d0-1.d0/3.d0*acos(gamma))
    
    !!!
    !!! Termes intermediaires
    !!!
    
    fact1=para(1)*sigc*r0c
    fact3=para(1)-1.d0
    
    !!!
    !!! Resultat final
    !!!
    
    call r8inir(6,0.d0,a,1)
    call r8inir(6,0.d0,dfdsig,1)
    
    do i=1,ndt
        a(i)=var(1)*ds2hds(i)+var(2)*kron(i)
    end do
    
    do i=1,ndt
        if (ucri.le.r8prem()) then
            dfdsig(i)=ds2hds(i)
        else
            dfdsig(i)=ds2hds(i)-fact1*a(i)*(ucri**fact3)
        endif
    end do

end subroutine
