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
subroutine rrcChck(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/romModeChck.h"
#include "asterfort/romTableChck.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: meshPrim, meshDual, modelPrim, modelDual
    character(len=8) :: modelRom, modelDom
    integer :: nbMode, nbStore
    aster_logical :: l_prev_dual, lTablFromResu
    type(ROM_DS_Field) :: modePrim, modeDual
    type(ROM_DS_Result) :: resultDom, resultRom
!
! --------------------------------------------------------------------------------------------------
!
    resultRom   = cmdPara%resultRom
    resultDom   = cmdPara%resultDom
    l_prev_dual = cmdPara%l_prev_dual
    modePrim    = cmdPara%ds_empi_prim%mode
    modeDual    = cmdPara%ds_empi_dual%mode
    modelRom    = cmdPara%model_rom
    modelDom    = cmdPara%model_dom
!
! - Check if COOR_REDUIT is OK (NB: no initial state => nbStore = nbStore - 1)
!
    lTablFromResu = resultRom%lTablFromResu
    nbMode        = cmdPara%ds_empi_prim%nbMode
    nbStore       = resultRom%nbStore - 1
    call romTableChck(cmdPara%tablReduCoor, lTablFromResu, nbMode, nbStoreIn_ = nbStore)
!
! - Check modes
!
    call romModeChck(modePrim)
    if (l_prev_dual) then
        call romModeChck(modeDual)
    endif
!
! - Check modes: mesh
!
    meshPrim    = modePrim%mesh
    meshDual    = modeDual%mesh
    if (l_prev_dual) then
        if (meshPrim .ne. meshDual) then
            call utmess('F','ROM16_20')
        endif
    endif
!
! - Check modes: model
!
    modelPrim   = modePrim%model
    modelDual   = modeDual%model
    if (l_prev_dual) then
        if (modelPrim .ne. modelDual) then
            call utmess('F', 'ROM16_21')
        endif
        if (modelDual .ne. modelDom) then
            call utmess('F', 'ROM16_22')
        endif
    endif
!
! - Check results
!
    if (modelRom .eq. modelDom) then
        call utmess('A', 'ROM16_23')
    endif
    if (modelPrim .ne. modelDom) then
        call utmess('F', 'ROM16_22')
    endif
!
end subroutine
