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

subroutine romSnapRead(result, ds_snap)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/rsutnu.h"
#include "asterfort/utmess.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in)  :: result
    type(ROM_DS_Snap), intent(inout) :: ds_snap
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Read parameters for snapshot selection
!
! --------------------------------------------------------------------------------------------------
! 
! In  result           : results datastructure for selection (EVOL_*)
! IO  ds_snap          : datastructure for snapshot selection
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nocc, iret
    integer :: nb_snap = 0
    real(kind=8) :: prec
    character(len=8)  :: crit = ' '
    character(len=24) :: list_snap = '&&ROM.LIST_SNAP'
    integer, pointer :: v_list_snap(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_4')
    endif
!
! - Select list of snapshots (from SNAP factor keyword)
!
    if (.false.) then
        call getfac('SNAP', nocc)
        ASSERT(nocc .le. 1)
        call getvr8('SNAP', 'PRECISION', iocc=1, scal=prec)
        call getvtx('SNAP', 'CRITERE'  , iocc=1, scal=crit)
        call rsutnu(result, 'SNAP', 1, list_snap, nb_snap, prec, crit, iret)
        if (iret .ne. 0) then
            call utmess('F', 'ROM2_11', sk = result)
        endif
        if (nb_snap .eq. 0) then
            call utmess('F','ROM2_10')
        endif
    else
        call rs_get_liststore(result, nb_snap)
        if (nb_snap .eq. 0) then
            call utmess('F','ROM2_10')
        endif
        call wkvect(list_snap, 'V V I', nb_snap, vi = v_list_snap)
        call rs_get_liststore(result, nb_snap, v_list_snap)
    endif
!
! - Save parameters in datastructure
!
    ds_snap%list_snap = list_snap
    ds_snap%nb_snap   = nb_snap
    ds_snap%result    = result
!
end subroutine
