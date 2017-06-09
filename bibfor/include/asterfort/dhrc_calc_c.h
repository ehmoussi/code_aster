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
    subroutine dhrc_calc_c(c0, ac, gc,&
                      vint, c, cp1, cp2, cs1,&
                      cs2)
        real(kind=8), intent(in) :: c0(2, 2, 2)
        real(kind=8), intent(in) :: ac(2, 2, 2)
        real(kind=8), intent(in) :: gc(2, 2, 2)
        real(kind=8), intent(in) :: vint(*)
        real(kind=8), intent(out) :: c(2, 2, 2)
        real(kind=8), intent(out) :: cp1(2, 2)
        real(kind=8), intent(out) :: cp2(2, 2)
        real(kind=8), intent(out) :: cs1(2, 2)
        real(kind=8), intent(out) :: cs2(2, 2)
    end subroutine dhrc_calc_c
end interface 
