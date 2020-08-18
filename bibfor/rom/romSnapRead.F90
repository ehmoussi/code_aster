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
subroutine romSnapRead(resultName, snap)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/getvis.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/as_allocate.h"
!
character(len=8), intent(in)  :: resultName
type(ROM_DS_Snap), intent(inout) :: snap
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Read parameters for snapshot selection
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results for selection
! IO  snap             : snapshot selection
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret, nbSnap
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM14_1')
    endif
!
! - Select list of snapshots (from LIST_SNAP keyword) or from result
!
    call getvis(' ','SNAPSHOT', nbret=iret)
    iret    = abs(iret)
    nbSnap = 0
    if (iret .gt. 1) then
        nbSnap = iret
        AS_ALLOCATE(vi = snap%listSnap, size = nbSnap)
        call getvis(' ','SNAPSHOT', nbval=nbSnap, vect=snap%listSnap)
    else
        call rs_get_liststore(resultName, nbSnap)
        if (nbSnap .eq. 0) then
            call utmess('F','ROM14_10')
        endif
        AS_ALLOCATE(vi = snap%listSnap, size = nbSnap)
        call rs_get_liststore(resultName, nbSnap, snap%listSnap)
    endif
!
! - Save parameters in datastructure
!
    snap%nbSnap = nbSnap
!
end subroutine
