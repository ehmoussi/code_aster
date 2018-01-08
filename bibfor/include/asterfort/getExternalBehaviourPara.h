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
    subroutine getExternalBehaviourPara(mesh           , v_model_elem  ,&
                                        rela_comp      , kit_comp      ,&
                                        l_comp_external, comp_exte     , &
                                        keywf_         , i_comp_       , elem_type_,&
                                        type_cpla_in_  , type_cpla_out_)
        use Behaviour_type
        character(len=8), intent(in) :: mesh
        integer, intent(in), pointer :: v_model_elem(:)
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: kit_comp(4)
        aster_logical, intent(out) :: l_comp_external
        type(Behaviour_External), intent(inout)   :: comp_exte
        character(len=16), optional, intent(in) :: keywf_
        integer, optional, intent(in) :: i_comp_
        integer, optional, intent(in) :: elem_type_
        character(len=16), optional, intent(in) :: type_cpla_in_
        character(len=16), optional, intent(out) :: type_cpla_out_
    end subroutine getExternalBehaviourPara
end interface
