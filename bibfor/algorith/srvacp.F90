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

subroutine srvacp(nbmat, mater, paraep, varpl)

!

!!!
!!! MODELE LKR : CALCUL DES FONCTIONS A^P, B^P, D^P ET K^P
!!!

! ===================================================================================
! IN  : NBMAT          : NOMBRE DE PARAMETRES DU MODELE
!     : MATER(NBMAT,2) : PARAMETRES DU MODELE
!     : PARAEP(3)      : VARIABLE D'ECROUISSAGE
!                          PARAEP(1) = AXIP
!                          PARAEP(2) = SXIP
!                          PARAEP(3) = MXIP
! OUT : VARPL(4)       : (ADXIP, BDXIP, DDXIP, KDXIP)
! ===================================================================================

    implicit      none
    
#include "asterc/r8pi.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat
    real(kind=8) :: paraep(3),mater(nbmat,2),varpl(4)
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: sigc,gamma,beta,r0c,pi
    real(kind=8) :: adxip,bdxip,ddxip,kdxip
    
    !!!
    !!! Recuperation de parametres materiaux
    !!!
    
    sigc=mater(3,2)
    beta=mater(4,2)
    gamma=mater(5,2)
    pi=r8pi()
    
    !!!
    !!! Calcul de k, a, b et d
    !!!
    
    r0c=cos(beta*pi/6.d0-1.d0/3.d0*acos(gamma))
    
    kdxip=(2.d0/3.d0)**(1.d0/2.d0/paraep(1))
    adxip=-paraep(3)*kdxip/sqrt(6.d0)/sigc/r0c
    bdxip=paraep(3)*kdxip/3.d0/sigc
    ddxip=paraep(2)*kdxip
    
    !!!
    !!! Stockage
    !!!
    
    varpl(1)=adxip
    varpl(2)=bdxip
    varpl(3)=ddxip
    varpl(4)=kdxip

end subroutine
