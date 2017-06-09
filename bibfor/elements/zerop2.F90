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

subroutine zerop2(b, c, x, n)
!
!
    implicit none
    real(kind=8) :: b, c, x(2)
    integer :: n
!
! ----------------------------------------------------------------------
! RESOLUTION D'UN POLYNOME DE DEGRE 2 : X**2 + B X + C = 0
! ----------------------------------------------------------------------
! IN  B,C   COEFFICIENTS DU POLYNOME
! OUT X     RACINES DANS L'ORDRE DECROISSANT
! OUT N     NOMBRE DE RACINES
! ----------------------------------------------------------------------
!
    real(kind=8) :: delta, rac
!
    delta = b**2 - 4*c
    if (delta .lt. 0) then
        n = 0
    else
        n = 2
        rac = sqrt(delta)
        x(1) = (-b+rac)/2
        x(2) = (-b-rac)/2
    endif
!
end subroutine
