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
    subroutine nmelcv(phase    , mesh     , model    , ds_material, ds_contact    ,&
                      disp_prev, vite_prev, acce_prev, vite_curr      , disp_cumu_inst,&
                      disp_newt_curr, vect_elem, time_prev, time_curr, ds_constitutive)
        use NonLin_Datastructure_type
        character(len=4), intent(in) :: phase
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: model
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: disp_prev
        character(len=19), intent(in) :: vite_prev
        character(len=19), intent(in) :: acce_prev
        character(len=19), intent(in) :: vite_curr
        character(len=19), intent(in) :: disp_cumu_inst
        character(len=19), intent(in) :: disp_newt_curr
        character(len=19), intent(out) :: vect_elem
        character(len=19), intent(in) :: time_prev
        character(len=19), intent(in) :: time_curr
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
    end subroutine nmelcv
end interface
