! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine load_list_getp(phenom      , l_load_user, v_llresu_info, v_llresu_name, v_list_dble,&
                              load_keyword, i_load     , nb_load      , i_excit      , load_name  ,&
                              load_type   , ligrch     , load_apply_  )
    character(len=4), intent(in) :: phenom
    aster_logical, intent(in) :: l_load_user
    character(len=8), pointer :: v_list_dble(:)
    integer, pointer :: v_llresu_info(:)
    character(len=24), pointer :: v_llresu_name(:)
    character(len=16), intent(in) :: load_keyword
    integer, intent(in) :: i_load
    integer, intent(in) :: nb_load
    integer, intent(inout) :: i_excit
    character(len=8), intent(out) :: load_name
    character(len=8), intent(out) :: load_type
    character(len=19), intent(out) :: ligrch
    character(len=16), optional, intent(out) :: load_apply_
    end subroutine load_list_getp
end interface
