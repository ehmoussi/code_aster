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
subroutine rrc_init(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/rrc_info.h"
#include "asterfort/rrc_init_dual.h"
#include "asterfort/rrc_init_prim.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/romTableRead.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_3')
    endif
!
! - Create datastructure of table in results datastructure for the reduced coordinates
!
    call romTableCreate(cmdPara%result_rom, cmdPara%tablReduCoor%tablResu)
!
! - Get reduced coordinates
!
    call romTableRead(cmdPara%tablReduCoor)
!
! - Type of result
!
    if (cmdPara%ds_empi_prim%mode%fieldName .eq. 'DEPL') then
        cmdPara%type_resu = 'EVOL_NOLI'
    elseif (cmdPara%ds_empi_prim%mode%fieldName .eq. 'TEMP') then
        cmdPara%type_resu = 'EVOL_THER'
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Create output result datastructure
!
    call rs_get_liststore(cmdPara%result_rom, cmdPara%nb_store)
    call rscrsd('G', cmdPara%result_dom, cmdPara%type_resu, cmdPara%nb_store)
!
! - Get model
!
    call dismoi('MODELE', cmdPara%result_rom, 'RESULTAT', repk=cmdPara%model_rom)
    if (cmdPara%model_rom .eq. '#PLUSIEURS') then
        call utmess('F', 'ROM6_36')
    endif
!
! - Initializations for primal base
!
    call rrc_init_prim(cmdPara)
!
! - Initializations for dual base
!
    if (cmdPara%l_prev_dual) then
        call rrc_init_dual(cmdPara)
    endif
!
! - Print parameters (debug)
!
    if (niv .ge. 2) then
        call rrc_info(cmdPara)
    endif
!
end subroutine
