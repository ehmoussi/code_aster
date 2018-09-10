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
    subroutine nmchfi(ds_algopara, list_func_acti, sddyna   , ds_contact,&
                      sddisc     , nume_inst     , iter_newt,&
                      lcfint     , lcdiri        , lcbudi   , lcrigi    ,&
                      option)
        use NonLin_Datastructure_type
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: sddisc, sddyna
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: nume_inst, iter_newt
        aster_logical, intent(out) :: lcfint, lcrigi, lcdiri, lcbudi
        character(len=16), intent(out) :: option
    end subroutine nmchfi
end interface
