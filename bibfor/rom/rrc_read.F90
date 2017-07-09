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
subroutine rrc_read(ds_para)
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
#include "asterfort/romBaseRead.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Read parameters
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_Empi) :: empi_prim, empi_dual, empi_rid
    character(len=8)  :: base_prim = ' ', base_dual = ' ', base_rid = ' '
    character(len=8)  :: result_dom = ' ', result_rom = ' ', model_dom = ' '
    character(len=16) :: k16bid = ' ', answer
    aster_logical :: l_prev_dual, l_corr_ef
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_10')
    endif
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
    call romBaseRead(base_prim, empi_prim)
!
! - Get informations about bases - Dual
!
    if (l_prev_dual) then
        call getvid(' ', 'BASE_DUAL', scal = base_dual)
        call romBaseRead(base_dual, empi_dual)
    endif
!
! - Correction by finite element
!
    call getvtx(' ', 'CORR_COMPLET', scal = answer)
    l_corr_ef = answer .eq. 'OUI'
!
! - Get informations about bases - Dual
!
    if (l_corr_ef) then
        call getvid(' ', 'BASE_DOMAINE', scal = base_rid)
        call romBaseRead(base_rid, empi_rid)
    endif
!
! - Get input results datastructures
!
    call getvid(' ', 'RESULTAT_REDUIT', scal = result_rom)
!
! - Get model
!
    call getvid(' ', 'MODELE', scal = model_dom)
!
! - Save parameters in datastructure
!
    ds_para%result_rom    = result_rom
    ds_para%result_dom    = result_dom
    ds_para%model_dom     = model_dom
    ds_para%ds_empi_prim  = empi_prim
    ds_para%ds_empi_dual  = empi_dual
    ds_para%l_prev_dual   = l_prev_dual
    ds_para%l_corr_ef     = l_corr_ef
    ds_para%ds_empi_rid   = empi_rid 
!
end subroutine
