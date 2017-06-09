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

!> Brief A processor ask the others to stop.
!
!> If imode = 1, one of the procs did not answer in the delay,
!> the execution must be interrupted by MPI_Abort.
!>
!> If imode = 2, all the processors synchronize themself and end with the
!> same utmess('s').
!> Should not be called in sequential.
!XXX I wrote that but why does it not work ? (MC)
!>
!> The caller should execute nothing after the call to asmpi_stop().
!
!> @param[in]   imode   interruption mode
!
subroutine asmpi_stop(imode)
! person_in_charge: mathieu.courtois at edf.fr

!

    use parameters_module, only : ST_ER_OTH, ST_EXCEPT
    implicit none
#include "asterf.h"
#include "asterf_debug.h"
#include "asterf_types.h"
#include "asterc/asabrt.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "asterfort/gtstat.h"
#include "asterfort/onerrf.h"
#include "asterfort/ststat.h"
    integer :: imode

    integer :: lout, imod2
    character(len=16) :: compex
    aster_logical :: labort
!
    call ststat(ST_ER_OTH)
    labort = .not. gtstat(ST_EXCEPT)
!
!   If an abort is required, force imode to 1
    imod2 = imode
    if (labort .and. imod2 == 2) then
        call onerrf(' ', compex, lout)
        if (compex(1:lout) == 'ABORT') then
            imod2 = 1
            DEBUG_MPI('mpi_stop ', 'mode forced to', imod2)
        endif
    endif
    DEBUG_MPI('mpi_stop', imod2, ' (1:abort, 2:except)')
!
    if (imod2 == 1) then
#ifdef _USE_MPI
        call utmess('D', 'APPELMPI_99')
#endif
        call asabrt(6)
!
    else if (imod2 == 2) then
        if (labort) then
            call utmess('M', 'APPELMPI_95')
        endif
!
    else
        ASSERT(.false.)
    endif
!
end subroutine
