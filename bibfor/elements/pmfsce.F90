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

subroutine pmfsce(nno, x, y, surf, centre)
    implicit none
    integer :: nno
    real(kind=8) :: x(4), y(4), surf, centre(2), deux, trois, quatre, pvect
    parameter (deux=2.d+0,trois=3.d+0,quatre=4.d+0)
!
! --- LA SURFACE D'UN TRIANGLE EST EGALE A LA MOITIE DE LA VALEUR
! --- ABSOLUE DU PRODUIT VECTORIEL DE 2 COTES
    pvect = (x(2)-x(1))* (y(3)-y(1)) - (y(2)-y(1))* (x(3)-x(1))
    surf = abs(pvect/deux)
! --- CAS DU TRIANGLE
    if (nno .eq. 3) then
        centre(1) = (x(1)+x(2)+x(3))/trois
        centre(2) = (y(1)+y(2)+y(3))/trois
    else
! --- SI QUADRILATERE, ON COUPE EN 2 TRIANGLES
        centre(1) = (x(1)+x(2)+x(3)+x(4))/quatre
        centre(2) = (y(1)+y(2)+y(3)+y(4))/quatre
        pvect = (x(4)-x(1))* (y(3)-y(1)) - (y(4)-y(1))* (x(3)-x(1))
        surf = surf + abs(pvect/deux)
    endif
end subroutine
