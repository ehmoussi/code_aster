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
    subroutine load_neut_prep(model, nb_in_maxi, nb_in_prep, lchin     , lpain,&
                              mate_, varc_curr_, temp_prev_, temp_iter_)
        character(len=24), intent(in) :: model
        integer, intent(in) :: nb_in_maxi
        character(len=8), intent(inout) :: lpain(nb_in_maxi)
        character(len=19), intent(inout) :: lchin(nb_in_maxi)
        integer, intent(out) :: nb_in_prep
        character(len=24), optional, intent(in) :: mate_
        character(len=19), optional, intent(in) :: varc_curr_
        character(len=19), optional, intent(in) :: temp_prev_
        character(len=19), optional, intent(in) :: temp_iter_
    end subroutine load_neut_prep
end interface
