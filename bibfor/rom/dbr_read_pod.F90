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
subroutine dbr_read_pod(operation, paraPod)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/romSnapRead.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romResultsGetInfo.h"
#include "asterfort/romTableParaRead.h"
!
character(len=16), intent(in) :: operation
type(ROM_DS_ParaDBR_POD), intent(inout) :: paraPod
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Read parameters - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  operation        : type of POD method
! IO  paraPod          : datastructure for parameters (POD)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc, ifm, niv
    real(kind=8) :: tole_svd, tole_incr
    character(len=16) :: field_name
    character(len=8)  :: axe_line, surf_num, base_type
    character(len=8)  :: result_in, model_user
    integer :: nb_mode_maxi
    type(ROM_DS_Snap) :: ds_snap
    type(ROM_DS_Result) :: ds_result
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_18')
    endif
!
! - Initializations
! 
    tole_svd     = 0.d0
    tole_incr    = 0.d0
    nb_mode_maxi = 0
    field_name   = ' '
    axe_line     = ' '
    surf_num     = ' '
    base_type    = ' '
    result_in    = ' '
    model_user   = ' '
!
! - Get parameters - Results to process
!
    call getvid(' ', 'RESULTAT', scal = result_in)
    call getvtx(' ', 'NOM_CHAM', scal = field_name, nbret = nocc)
    ASSERT(nocc .eq. 1)
    call getvid(' ', 'MODELE'  , scal = model_user, nbret = nocc)
    if (nocc .ne. 1) then
        model_user = ' '
    endif
!
! - Maximum number of modes
!
    call getvis(' ', 'NB_MODE' , scal = nb_mode_maxi, nbret = nocc)
    if (nocc .eq. 0) then
        nb_mode_maxi = 0
    endif
!
! - Get parameters - Base type to numbering
!
    call getvtx(' ', 'TYPE_BASE', scal = base_type)
    if (base_type .eq. 'LINEIQUE') then
        call getvtx(' ', 'AXE', scal = axe_line, nbret = nocc)
        ASSERT(nocc .eq. 1)
        call getvtx(' ', 'SECTION', scal = surf_num, nbret = nocc)
        ASSERT(nocc .eq. 1)
    endif
!
! - Get parameters - For SVD selection
!
    call getvr8(' ', 'TOLE_SVD', scal = tole_svd)
    if (operation .eq. 'POD_INCR') then
        call getvr8(' ', 'TOLE', scal = tole_incr)
        call romTableParaRead(paraPod%tablReduCoor)
    endif
!
! - Read parameters for snapshot selection
!
    ds_snap = paraPod%ds_snap
    call romSnapRead(result_in, ds_snap)
!
! - Get parameters for result datastructure
!
    ds_result = paraPod%ds_result_in
    call romResultsGetInfo(result_in, field_name, model_user, ds_result)
!
! - Save parameters in datastructure
!
    paraPod%ds_result_in = ds_result
    paraPod%field_name   = field_name
    paraPod%base_type    = base_type
    paraPod%axe_line     = axe_line
    paraPod%surf_num     = surf_num
    paraPod%tole_svd     = tole_svd
    paraPod%tole_incr    = tole_incr
    paraPod%ds_snap      = ds_snap
    paraPod%nb_mode_maxi = nb_mode_maxi
    paraPod%model_user   = model_user
!
end subroutine
