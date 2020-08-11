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
subroutine rrcInfo(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Informations
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: model_dom, model_rom
    aster_logical :: l_prev_dual, l_corr_ef
!
! --------------------------------------------------------------------------------------------------
!
    model_rom    = cmdPara%model_rom
    model_dom    = cmdPara%model_dom
    l_prev_dual  = cmdPara%l_prev_dual
    l_corr_ef    = cmdPara%l_corr_ef
!
! - Print
!
    call utmess('I', 'ROM16_50', sk = cmdPara%resultRom%resultType)
    call utmess('I', 'ROM16_51', si = cmdPara%resultRom%nbStore)
    if (l_prev_dual) then
        call utmess('I', 'ROM16_52')
    endif
    if (l_corr_ef) then
        call utmess('I', 'ROM16_53')
    endif
!
end subroutine
