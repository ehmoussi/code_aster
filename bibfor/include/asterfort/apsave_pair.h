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
    subroutine apsave_pair(i_zone      , elem_slav_nume,&
                           nb_pair     , list_pair     ,&
                           nb_pair_zone, list_pair_zone)
        integer, intent(in) :: i_zone
        integer, intent(in) :: elem_slav_nume
        integer, intent(in) :: nb_pair
        integer, intent(in) :: list_pair(:)
        integer, intent(inout) :: nb_pair_zone
        integer, pointer :: list_pair_zone(:)
    end subroutine apsave_pair
end interface
