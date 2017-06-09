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
    subroutine nmchrm(phasis     , ds_algopara, list_func_acti, sddisc   , sddyna   ,&
                      nume_inst  , iter_newt  , ds_contact    , type_pred, type_corr,&
                      l_matr_asse)
        use NonLin_Datastructure_type
        character(len=10), intent(in) :: phasis
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=19), intent(in) :: sddisc
        character(len=19), intent(in) :: sddyna
        integer, intent(in) :: nume_inst
        integer, intent(in) :: iter_newt
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: list_func_acti(*)
        character(len=16), intent(out) :: type_corr
        character(len=16), intent(out) :: type_pred
        aster_logical, intent(out) :: l_matr_asse
    end subroutine nmchrm
end interface
