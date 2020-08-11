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
#include "asterf_types.h"
!
interface
    subroutine romBaseSave(base       , nbMode     , nbSnap,&
                           mode_type  , fieldIden  ,&
                           mode_vectr_, mode_vectc_,&
                           v_modeSing_, v_numeSlice_)
        use Rom_Datastructure_type
        type(ROM_DS_Empi), intent(in) :: base
        integer, intent(in) :: nbMode, nbSnap
        character(len=1), intent(in) :: mode_type
        character(len=24), intent(in) :: fieldIden
        real(kind=8), optional, pointer :: mode_vectr_(:)
        complex(kind=8), optional, pointer :: mode_vectc_(:)
        real(kind=8), optional, pointer :: v_modeSing_(:)
        integer, optional, pointer      :: v_numeSlice_(:)
    end subroutine romBaseSave
end interface
