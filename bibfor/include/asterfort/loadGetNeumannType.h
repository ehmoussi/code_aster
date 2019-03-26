! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine loadGetNeumannType(l_stat      , load_name   , ligrch        ,&
                                  load_apply  , load_type   ,&
                                  nb_info_type, nb_info_maxi, list_info_type)
        aster_logical, intent(in) :: l_stat
        character(len=8), intent(in) :: load_name
        character(len=19), intent(in) :: ligrch
        character(len=16), intent(in) :: load_apply
        character(len=8), intent(in) :: load_type
        integer, intent(inout) :: nb_info_type
        integer, intent(in) :: nb_info_maxi
        character(len=24), intent(inout)  :: list_info_type(nb_info_maxi)
    end subroutine loadGetNeumannType
end interface
