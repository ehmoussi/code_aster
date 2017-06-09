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
#include "asterf_types.h"
!
interface
    subroutine nxlect(result       , model     , ther_crit_i, ther_crit_r, ds_inout,&
                      ds_algopara  , ds_algorom, result_dry , compor     , l_dry   ,&
                      l_line_search)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        character(len=8), intent(in) :: result
        character(len=24), intent(in) :: model
        integer, intent(inout) :: ther_crit_i(*)
        real(kind=8), intent(inout) :: ther_crit_r(*)
        type(NL_DS_InOut), intent(inout) :: ds_inout
        type(NL_DS_AlgoPara), intent(inout) :: ds_algopara
        type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
        character(len=8), intent(out) :: result_dry
        character(len=24), intent(out) :: compor
        aster_logical, intent(out) :: l_dry
        aster_logical, intent(out) :: l_line_search
    end subroutine nxlect
end interface
