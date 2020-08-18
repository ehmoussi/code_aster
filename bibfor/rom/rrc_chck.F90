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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rrc_chck(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/romModeChck.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: meshPrim, meshDual, modelPrim, modelDual
    character(len=8) :: modelRom, modelDom
    aster_logical :: l_corr_ef, l_prev_dual
    type(ROM_DS_Field) :: modePrim, modeDual
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get parameters
!
    l_corr_ef   = cmdPara%l_corr_ef
    l_prev_dual = cmdPara%l_prev_dual
    modePrim    = cmdPara%ds_empi_prim%mode
    modeDual    = cmdPara%ds_empi_dual%mode
    meshPrim    = modePrim%mesh
    meshDual    = modeDual%mesh
    modelPrim   = modePrim%model
    modelDual   = modeDual%model
    modelRom    = cmdPara%model_rom
    modelDom    = cmdPara%model_dom
!
! - Check existence of reduced coordinates
!
    if (cmdPara%tablReduCoor%tablResu%tablName .eq. ' ') then
        if (.not. cmdPara%tablReduCoor%lTablUser) then
            call utmess('F', 'ROM6_4')
        endif
    endif
!
! - Check mesh
!
    if (l_prev_dual) then
        if (meshPrim .ne. meshDual) then
            call utmess('F','ROM4_9')
        endif
    endif
!
! - Check model
!
    if (modelRom .eq. modelDom) then
        call utmess('A', 'ROM6_8')
    endif
    if (modelPrim .ne. modelDom) then
        call utmess('F', 'ROM6_9', sk = cmdPara%ds_empi_prim%resultName)
    endif
!
    if (l_prev_dual) then
        if (modelPrim .ne. modelDual) then
            call utmess('F', 'ROM6_2')
        endif
        if (modelDual .ne. modelDom) then
            call utmess('F', 'ROM6_9', sk = cmdPara%ds_empi_dual%resultName)
        endif
    endif
!
! - Check mode
!
    call romModeChck(modePrim)
    if (l_prev_dual) then
        call romModeChck(modeDual)
    endif
!
end subroutine
