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

subroutine srvacv(nbmat,mater,paravi,varvi)

!

!!!
!!! MODELE LKR : CALCUL DES FONCTIONS A^VP, B^VP, D^VP ET K^VP
!!!

! ===================================================================================
! IN  : NBMAT          : NOMBRE DE PARAMETRES DU MODELE
!     : MATER(NBMAT,2) : PARAMETRES DU MODELE
!     : PARAVI(3)      : PARAMETRES D'ECROUISSAGE VISCO.
!                          PARAVI(1) = AXIV
!                          PARAVI(2) = SXIV
!                          PARAVI(3) = MXIV
! OUT : VARVI(4)       : (AVXIV, BVXIV, DVXIV, KXIV)
! ===================================================================================

    implicit      none

#include "asterc/r8pi.h"

    !!!
    !!! Variables globales
    !!!
   
    integer :: nbmat
    real(kind=8) :: mater(nbmat,2),paravi(3),varvi(4)
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: sigc,gamma,beta,r0c,avxiv,bvxiv,kvxiv,dvxiv
    real(kind=8) :: pi
    
    !!!
    !!! Recuperation des parametres du modele
    !!!
    
    sigc=mater(3,2)
    beta=mater(4,2)
    gamma=mater(5,2)
    pi=r8pi()
    
    !!!
    !!! Calcul de k, a, b et d
    !!!
    
    r0c=cos(beta*pi/6.d0-1.d0/3.d0*acos(gamma))
    
    kvxiv=(2.d0/3.d0)**(1.d0/2.d0/paravi(1))
    avxiv=-paravi(3)*kvxiv/sqrt(6.d0)/sigc/r0c
    bvxiv=paravi(3)*kvxiv/3.d0/sigc
    dvxiv=paravi(2)*kvxiv

    !!!
    !!! Stockage
    !!!
    
    varvi(1)=avxiv
    varvi(2)=bvxiv
    varvi(3)=dvxiv
    varvi(4)=kvxiv

end subroutine
