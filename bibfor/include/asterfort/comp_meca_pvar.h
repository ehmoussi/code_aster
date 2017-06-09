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
    subroutine comp_meca_pvar(model_      , compor_cart_, compor_list_, compor_info)
        character(len=8), optional, intent(in) :: model_
        character(len=19), optional, intent(in) :: compor_cart_
        character(len=16), optional, intent(in) :: compor_list_(20)
        character(len=19), intent(in) :: compor_info
    end subroutine comp_meca_pvar
end interface
