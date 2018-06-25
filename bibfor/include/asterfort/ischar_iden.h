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
!
#include "asterf_types.h"
!
interface
    function ischar_iden(v_load_info, i_load, nb_load, load_type_1, load_type_2)
        integer, pointer :: v_load_info(:)
        integer, intent(in) :: i_load
        integer, intent(in) :: nb_load
        aster_logical :: ischar_iden
        character(len=4), intent(in) :: load_type_1
        character(len=4), intent(in) :: load_type_2
    end function ischar_iden
end interface
