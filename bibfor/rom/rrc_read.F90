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
subroutine rrc_read(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romTableParaRead.h"
#include "asterfort/romBaseGetInfo.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Read parameters
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_Empi) :: empi_prim, empi_dual
    character(len=8)  :: base_prim , base_dual
    character(len=8)  :: result_dom , result_rom , model_dom
    character(len=16) :: k16bid , answer
    character(len=24) :: grnode_int
    aster_logical :: l_prev_dual, l_corr_ef
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_10')
    endif
!
! - Initializations
!
    base_prim  = ' '
    base_dual  = ' '
    result_dom = ' '
    result_rom = ' '
    model_dom  = ' '
    k16bid     = ' '
!
! - Output datastructure
!
    call getres(result_dom, k16bid, k16bid)
!
! - Compute dual quantities ?
!
    call getvtx(' ', 'REST_DUAL', scal = answer)
    l_prev_dual = answer .eq. 'OUI'
!
! - Get informations about bases - Primal
!
    call getvid(' ', 'BASE_PRIMAL', scal = base_prim)
    call romBaseGetInfo(base_prim, empi_prim)
    if (empi_prim%ds_mode%fieldSupp .ne. 'NOEU') then
        call utmess('F', 'ROM6_5')
    endif
!
! - Get informations about bases - Dual
!
    if (l_prev_dual) then
        call getvid(' ', 'BASE_DUAL', scal = base_dual)
        call romBaseGetInfo(base_dual, empi_dual)
        if (empi_dual%ds_mode%fieldSupp .ne. 'NOEU') then
            call utmess('F', 'ROM6_5')
        endif
        call getvtx(' ', 'GROUP_NO_INTERF', scal = grnode_int)
    endif
!
! - Correction by finite element
!
    call getvtx(' ', 'CORR_COMPLET', scal = answer)
    l_corr_ef = answer .eq. 'OUI'
!
! - Get input results datastructures
!
    call getvid(' ', 'RESULTAT_REDUIT', scal = result_rom)
!
! - Get model
!
    call getvid(' ', 'MODELE', scal = model_dom)
!
! - Get parameters
!
    call romTableParaRead(cmdPara%tablReduCoor)
!
! - Save parameters in datastructure
!
    cmdPara%result_rom   = result_rom
    cmdPara%result_dom   = result_dom
    cmdPara%model_dom    = model_dom
    cmdPara%ds_empi_prim = empi_prim
    cmdPara%ds_empi_dual = empi_dual
    cmdPara%grnode_int   = grnode_int
    cmdPara%l_prev_dual  = l_prev_dual
    cmdPara%l_corr_ef    = l_corr_ef
!
end subroutine
