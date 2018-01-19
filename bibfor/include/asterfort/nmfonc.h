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
#include "asterf_types.h"
!
interface
    subroutine nmfonc(ds_conv       , ds_algopara    , solver   , model     , ds_contact     ,&
                      list_load     , sdnume         , sddyna   , sdcriq    , mate           ,&
                      ds_inout      , ds_constitutive, ds_energy, ds_algorom, ds_posttimestep,&
                      list_func_acti)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        type(NL_DS_Conv), intent(in) :: ds_conv
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=19), intent(in) :: solver
        character(len=24), intent(in) :: model
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: list_load
        character(len=19), intent(in) :: sdnume
        character(len=19), intent(in) :: sddyna
        character(len=24), intent(in) :: sdcriq
        character(len=24), intent(in) :: mate
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Energy), intent(in) :: ds_energy
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        type(NL_DS_PostTimeStep), intent(in) :: ds_posttimestep
        integer, intent(inout) :: list_func_acti(*)
    end subroutine nmfonc
end interface
