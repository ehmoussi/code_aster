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
subroutine dbr_init_algo_tr(ds_para_tr)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/gnomsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/numero.h"
#include "asterfort/modelNodeEF.h"
#include "asterfort/romCreateEquationFromNode.h"
!
type(ROM_DS_ParaDBR_TR), intent(inout) :: ds_para_tr
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Init algorithm - For truncation
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para_tr       : datastructure for truncation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_equa_rom, nb_node_rom
    character(len=8) :: model_rom, model_dom
    character(len=24) :: nume_rom, nume_dom, noojb
    integer, pointer :: v_node_rom(:) => null()
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
    noojb     = '12345678.00000.NUME.PRNO'
    model_dom = ds_para_tr%ds_empi_init%model
    model_rom = ds_para_tr%model_rom
!
! - Create numbering
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_48')
    endif
    nume_rom = '12345678.NUMED'
    call gnomsd(' ', noojb, 10, 14)
    nume_rom = noojb(1:14)
    call numero(nume_rom, 'VV', modelz = model_rom)
    nume_dom = '12345678.NUMED'
    call gnomsd(' ', noojb, 10, 14)
    nume_dom = noojb(1:14)
    call numero(nume_dom, 'VV', modelz = model_dom)
    call dismoi('NB_EQUA'  , nume_rom, 'NUME_DDL', repi=nb_equa_rom)
!
! - Extract list of nodes on reduced model
!
    call modelNodeEF(model_rom, nb_node_rom, v_node_rom)
!
! - Prepare the list of equations from list of nodes
!
    call romCreateEquationFromNode(ds_para_tr%ds_empi_init,&
                                   ds_para_tr%v_equa_rom,&
                                   nume_dom     ,&
                                   nb_node_     = nb_node_rom,&
                                   v_list_node_ = v_node_rom)
!
! - Save parameters
!
    ds_para_tr%nb_equa_rom   = nb_equa_rom
!
end subroutine
