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
    subroutine nmelcv(mesh          , model         ,&
                      ds_material   , ds_contact    , ds_constitutive,&
                      disp_prev     , vite_prev     ,&
                      acce_prev     , vite_curr     ,&
                      time_prev     , time_curr     ,&
                      disp_cumu_inst, disp_newt_curr,&
                      vect_elem_cont, vect_elem_fric)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: model
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Contact), intent(in) :: ds_contact
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19), intent(in) :: disp_prev, vite_prev, acce_prev, vite_curr
        character(len=19), intent(in) :: time_prev, time_curr
        character(len=19), intent(in) :: disp_cumu_inst, disp_newt_curr
        character(len=19), intent(out) :: vect_elem_cont, vect_elem_fric
    end subroutine nmelcv
end interface
