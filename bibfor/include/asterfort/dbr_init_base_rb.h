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
    subroutine dbr_init_base_rb(base, ds_para_rb, nb_mode, ds_empi)
        use Rom_Datastructure_type
        character(len=8), intent(in) :: base
        type(ROM_DS_ParaDBR_RB), intent(in) :: ds_para_rb
        integer, intent(in) :: nb_mode
        type(ROM_DS_Empi), intent(inout) :: ds_empi
    end subroutine dbr_init_base_rb
end interface
