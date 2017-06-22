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
    subroutine ccchuc_norm(norm, model, name_gd, field_in, type_field_in, &
                           field_out)
        character(len=16) , intent(in) :: norm
        character(len=8), intent(in) :: model
        character(len=8), intent(in) :: name_gd
        character(len=19), intent(in) :: field_in
        character(len=4), intent(in) :: type_field_in
        character(len=19), intent(in) :: field_out
    end subroutine ccchuc_norm
end interface
