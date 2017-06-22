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

subroutine srhtet(nbmat, mater, rcos3t, r0c, rtheta)

!

!!!
!!! MODELE LKR : CALCUL DE H(THETA)
!!!

! ===================================================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES MATERIAU
!     : MATER  : COEFFICIENTS MATERIAU
!                    MATER(*,1) = CARACTERISTIQUES ELASTIQUES
!                    MATER(*,2) = CARACTERISTIQUES PLASTIQUES
!     : RCOS3T : COS(3THETA)
! OUT : H0E    : PARAMETRE UTILISES DANS LE CRITERE
!     : H0C    : PARAMETRE UTILISES DANS LE CRITERE
!     : HTHETA : H(THETA)
! ===================================================================================

    implicit none

#include "asterc/r8pi.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat
    real(kind=8) :: mater(nbmat,2),rcos3t,r0c,rtheta
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: gamma,pi,beta
    
    !!!
    !!! Recuperation des parametres du modele
    !!!
    
    pi=r8pi()
    beta=mater(4,2)
    gamma=mater(5,2)
    
    !!!
    !!! Calcul de h0c et h(theta) (r0c et r(theta))
    !!!
    
    r0c=cos(beta*pi/6.d0-1.d0/3.d0*acos(gamma))
    rtheta=cos(beta*pi/6.d0-1.d0/3.d0*acos(gamma*rcos3t))
    
end subroutine
