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

subroutine romSnapRead(result, ds_snap)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
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
    integer :: iret
    integer :: nb_snap
    character(len=24), parameter :: list_snap = '&&ROM.LIST_SNAP'
    integer, pointer :: v_list_snap(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_4')
    endif
!
    nb_snap = 0
!
! - Select list of snapshots (from LIST_SNAP keyword) or from result
!
    call getvis('','SNAPSHOT', nbret=iret)
    iret=abs(iret)
    if (iret .gt. 1) then
        nb_snap = iret
        call wkvect(list_snap, 'V V I', nb_snap, vi = v_list_snap)
        call getvis('','SNAPSHOT', nbval=nb_snap, vect=v_list_snap)
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
