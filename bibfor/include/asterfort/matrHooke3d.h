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

!
interface
    subroutine matrHooke3d(elas_type, repere,&
                           e , nu, g,&
                           e1, e2, e3, nu12, nu13, nu23, g1, g2, g3,&
                           matr_elas , xyzgau_)
        integer, intent(in) :: elas_type
        real(kind=8), intent(in) :: repere(7)
        real(kind=8), intent(in) :: e
        real(kind=8), intent(in) :: nu
        real(kind=8), intent(in) :: g
        real(kind=8), intent(in) :: e1, e2, e3
        real(kind=8), intent(in) :: nu12, nu13, nu23
        real(kind=8), intent(in) :: g1, g2, g3
        real(kind=8), intent(out) :: matr_elas(6, 6)
        real(kind=8), optional, intent(in) :: xyzgau_(3)
    end subroutine matrHooke3d
end interface
