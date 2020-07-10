! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine lrm_clean_joint(rang, domdis, nbproc, v_noex, name_join_old, name_join_new)
        integer, intent(in) :: rang, domdis, nbproc
        integer, intent(inout) :: v_noex(*)
        character(len=24), intent(in) :: name_join_old, name_join_new
    end subroutine lrm_clean_joint
end interface
