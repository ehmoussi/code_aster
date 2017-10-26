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
subroutine ddr_DSInit(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/infniv.h"
#include "asterfort/romBaseDSInit.h"
#include "asterfort/romLineicBaseDSInit.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDDR), intent(out) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Initializations
!
! Initialization of datastructures
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_Empi) :: empi_prim, empi_dual
    type(ROM_DS_LineicNumb) :: ds_lineicnumb
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM4_24')
    endif
!
! - Creation of datastructure for lineic base numbering
!
    call romLineicBaseDSInit(ds_lineicnumb)
!
! - Create datastructure for empiric modes
!
    call romBaseDSInit(ds_lineicnumb, empi_prim)
    call romBaseDSInit(ds_lineicnumb, empi_dual)
!
! - Create parameters datastructure
!
    ds_para%mesh          = ' '
    ds_para%ds_empi_prim  = empi_prim
    ds_para%ds_empi_dual  = empi_dual
    ds_para%grelem_rid    = ' '
    ds_para%nb_layer_rid  = 0
    ds_para%grnode_int    = ' '
    ds_para%l_corr_ef     = .false._1
    ds_para%grnode_sub    = ' '
    ds_para%nb_rid_mini   = 0
    ds_para%v_rid_mini    => null()
    ds_para%l_rid_maxi    = .false._1
    ds_para%v_rid_maxi    => null()
    ds_para%nb_rid_maxi   = 0
    ds_para%nb_layer_sub  = 0
!
end subroutine
