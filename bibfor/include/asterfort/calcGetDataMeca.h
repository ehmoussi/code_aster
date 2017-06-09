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
    subroutine calcGetDataMeca(list_load      , model         , mate     , cara_elem,&
                               disp_prev      , disp_cumu_inst, vari_prev, sigm_prev,&
                               ds_constitutive, l_elem_nonl, nume_harm)
        use NonLin_Datastructure_type
        character(len=19), intent(out) :: list_load
        character(len=24), intent(out) :: model
        character(len=24), intent(out) :: mate
        character(len=24), intent(out) :: cara_elem
        character(len=19), intent(out) :: disp_prev
        character(len=19), intent(out) :: disp_cumu_inst
        character(len=19), intent(out) :: vari_prev
        character(len=19), intent(out) :: sigm_prev
        type(NL_DS_Constitutive), intent(out) :: ds_constitutive
        aster_logical, intent(out) :: l_elem_nonl
        integer, intent(out) :: nume_harm
    end subroutine calcGetDataMeca
end interface
