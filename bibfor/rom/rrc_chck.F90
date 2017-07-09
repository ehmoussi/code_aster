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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rrc_chck(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/romBaseChck.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: mesh_prim, mesh_dual, model_prim, model_dual
    character(len=8) :: model_rom, model_dom
    aster_logical :: l_prev_dual
!
! --------------------------------------------------------------------------------------------------
!
    if (ds_para%tabl_name .eq. ' ') then
        call utmess('F', 'ROM6_4')
    endif
!
! - Get parameters
!
    l_prev_dual = ds_para%l_prev_dual
    mesh_prim   = ds_para%ds_empi_prim%mesh
    mesh_dual   = ds_para%ds_empi_dual%mesh
    model_prim  = ds_para%ds_empi_prim%model
    model_dual  = ds_para%ds_empi_dual%model
    model_rom   = ds_para%model_rom
    model_dom   = ds_para%model_dom
!
! - Check mesh
!
    if (l_prev_dual) then
        if (mesh_prim .ne. mesh_dual) then
            call utmess('F','ROM4_9')
        endif
    endif
!
! - Check model
!
    if (model_prim .eq. '#PLUSIEURS') then
        call utmess('F','ROM4_11')
    endif
    if (model_rom .eq. model_dom) then
        call utmess('A', 'ROM6_8')
    endif
    if (model_prim .ne. model_dom) then
        call utmess('F', 'ROM6_9', sk = ds_para%ds_empi_prim%base)
    endif
!
    if (l_prev_dual) then
        if (model_dual .eq. '#PLUSIEURS') then
            call utmess('F','ROM4_11')
        endif
        if (model_prim .ne. model_dual) then
            call utmess('F', 'ROM6_2')
        endif
        if (model_dual .ne. model_dom) then
            call utmess('F', 'ROM6_9', sk = ds_para%ds_empi_dual%base)
        endif
    endif
!
! - Check empiric modes base
!
    call romBaseChck(ds_para%ds_empi_prim)
    if (l_prev_dual) then
        call romBaseChck(ds_para%ds_empi_dual)
    endif
!
end subroutine
