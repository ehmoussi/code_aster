! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine dbr_read_rb(ds_para_rb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cresol.h"
#include "asterfort/infniv.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/romMultiParaRead.h"
#include "asterfort/utmess.h"
#include "asterfort/getvr8.h"
!
type(ROM_DS_ParaDBR_RB), intent(inout) :: ds_para_rb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Read parameters - For RB methods
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para_rb       : datastructure for parameters (RB)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_mode_maxi = 0, nocc
    character(len=16) :: stab_fsi = ' ', ortho_base = ' '
    aster_logical :: l_stab_fsi, l_ortho_base
    real(kind=8) :: tole_greedy
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_27')
    endif
!
! - Maximum number of modes
!
    call getvis(' ', 'NB_MODE' , scal = nb_mode_maxi, nbret = nocc)
    ASSERT(nocc .eq. 1 .and. nb_mode_maxi .ge. 1)
!
! - If we orthogonalize basis
!
    call getvtx(' ', 'ORTHO_BASE', scal = ortho_base)
    l_ortho_base = ortho_base .eq. 'OUI'
!
! - If we stabilise the basis for FSI transient problem
!
    call getvtx(' ', 'TYPE_BASE', scal = stab_fsi)
    l_stab_fsi = stab_fsi .eq. 'IFS_STAB'
!
! - Read tolerance
!
    call getvr8(' ', 'TOLE_GLOUTON', scal = tole_greedy)
!
! - Read data for multiparametric problems
!
    call romMultiParaRead(ds_para_rb%multipara)
!
! - Read solver parameters
!
    call cresol(ds_para_rb%solver)
!
! - Save parameters in datastructure
!
    ds_para_rb%nb_mode_maxi = nb_mode_maxi
    ds_para_rb%l_ortho_base = l_ortho_base
    ds_para_rb%l_stab_fsi   = l_stab_fsi
    ds_para_rb%tole_greedy  = tole_greedy
!
end subroutine
