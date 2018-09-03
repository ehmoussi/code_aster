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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rrc_info(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Informations
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: type_resu
    character(len=8) :: result_rom, result_dom, model_dom, model_rom
    integer :: nb_store
    aster_logical :: l_prev_dual, l_corr_ef
!
! --------------------------------------------------------------------------------------------------
!
    type_resu    = ds_para%type_resu
    result_rom   = ds_para%result_rom
    model_rom    = ds_para%model_rom
    nb_store     = ds_para%nb_store
    result_dom   = ds_para%result_dom
    model_dom    = ds_para%model_dom
    l_prev_dual  = ds_para%l_prev_dual
    l_corr_ef    = ds_para%l_corr_ef
!
! - Print
!
    call utmess('I', 'ROM6_7', sk = type_resu)
    call utmess('I', 'ROM6_11', si = nb_store)
    if (l_prev_dual) then
        call utmess('I', 'ROM6_14')
    endif
    if (l_corr_ef) then
        call utmess('I', 'ROM6_15')
    endif
!
end subroutine
