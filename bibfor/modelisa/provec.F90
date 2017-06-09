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

subroutine provec(xx, yy, normal)
    implicit none
    real(kind=8) :: xx(3), yy(3), normal(3)
!     BUT : CALCUL DU PRODUIT VECTORIEL DE DEUX VECTEURS
!
    normal(1) = xx(2)*yy(3) - xx(3)*yy(2)
    normal(2) = xx(3)*yy(1) - xx(1)*yy(3)
    normal(3) = xx(1)*yy(2) - xx(2)*yy(1)
end subroutine
