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

function coegen(d1, d2, d3, l, omega,&
                uc)
    implicit none
!
! *****************   DECLARATIONS DES VARIABLES   ********************
!
!
! ARGUMENTS
! ---------
#include "jeveux.h"
    real(kind=8) :: d1, d2, d3, omega, l, uc
!
!
! VARIABLES LOCALES
! -----------------
    real(kind=8) :: coegen, dist
!
! CALCUL DE LA DISTANCE INTERPOINTS DE GAUSS
!
    dist=sqrt(d1**2 + d2**2 + d3**2)
!
! CALCUL DE LA FONCTION DE COHERENCE
!
    coegen=exp(-dist/l)*cos(omega*dist/uc)
!
!
end function
