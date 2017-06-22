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
!
interface 
    subroutine dhrc_calc_g(eps, vint, ap1, bp1, cp1,&
                      ap2, bp2, cp2, g1, g2)
        real(kind=8), intent(in) :: eps(6)
        real(kind=8), intent(in) :: vint(*)
        real(kind=8), intent(in) :: ap1(6, 6)
        real(kind=8), intent(in) :: bp1(6, 2)
        real(kind=8), intent(in) :: cp1(2, 2)
        real(kind=8), intent(in) :: ap2(6, 6)
        real(kind=8), intent(in) :: bp2(6, 2)
        real(kind=8), intent(in) :: cp2(2, 2)
        real(kind=8), intent(out) :: g1
        real(kind=8), intent(out) :: g2
    end subroutine dhrc_calc_g
end interface 
