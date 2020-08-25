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
subroutine dbr_init_algo_tr(paraTrunc)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/gnomsd.h"
#include "asterfort/infniv.h"
#include "asterfort/modelNodeEF.h"
#include "asterfort/numero.h"
#include "asterfort/romFieldNodesAreDefined.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_TR), intent(inout) :: paraTrunc
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Init algorithm for truncation of base
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraTrunc         : datastructure for truncation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbEquaRom, nbNodeRom
    character(len=8) :: modelRom, modelDom
    character(len=24) :: numeRom, numeDom, noojb
    integer, pointer :: numeNodeRom(:) => null()
    type(ROM_DS_Field) :: mode
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_47')
    endif
!
! - Get parameters
!
    noojb    = '12345678.00000.NUME.PRNO'
    mode     = paraTrunc%ds_empi_init%ds_mode
    modelRom = paraTrunc%model_rom
    modelDom = paraTrunc%ds_empi_init%ds_mode%model
!
! - Create numbering for ROM
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_48')
    endif
    numeRom = '12345678.NUMED'
    call gnomsd(' ', noojb, 10, 14)
    numeRom = noojb(1:14)
    call numero(numeRom, 'VV', modelz = modelRom)
!
! - Create numbering for DOM
!
    numeDom = '12345678.NUMED'
    call gnomsd(' ', noojb, 10, 14)
    numeDom = noojb(1:14)
    call numero(numeDom, 'VV', modelz = modelDom)
!
! - Extract list of nodes on reduced model
!
    call modelNodeEF(modelRom, nbNodeRom, numeNodeRom)
!
! - Prepare the list of equations from list of nodes
!
    call romFieldNodesAreDefined(mode, paraTrunc%v_equa_rom, numeDom,&
                                 nbNode_   = nbNodeRom,&
                                 listNode_ = numeNodeRom)
!
! - Save parameters
!
    call dismoi('NB_EQUA', numeRom, 'NUME_DDL', repi = nbEquaRom)
    paraTrunc%nb_equa_rom = nbEquaRom
!
end subroutine
