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

subroutine eiangl(ndim, nno2, angnau, ang)
    implicit none
#include "asterc/r8dgrd.h"
    integer :: ndim, nno2
    real(kind=8) :: angnau(3), ang(24)
!
!--------------------------------------------------
!  DEFINITION DES ANGLES NAUTIQUES AUX NOEUDS
!  EN RADIAN POUR L'ELEMENT D'INTERFACE
!
!  IN  : NDIM,NNO2
!        ANGNAU : ANGLES NAUTIQUES EN DEGRES
!  OUT :
!        ANG : ANGLES NAUTIQUES AUX NOEUDS EN RADIAN
!--------------------------------------------------
    integer :: n
!
    if (ndim .eq. 2) then
        do 10 n = 1, nno2
            ang(n) = angnau(1)*r8dgrd()
10      continue
    else
        do 20 n = 1, nno2
            ang(1 + (n-1)*3) = angnau(1)*r8dgrd()
            ang(2 + (n-1)*3) = angnau(2)*r8dgrd()
            ang(3 + (n-1)*3) = angnau(3)*r8dgrd()
20      continue
    endif
!
end subroutine
