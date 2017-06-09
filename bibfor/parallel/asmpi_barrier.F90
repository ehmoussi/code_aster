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

subroutine asmpi_barrier(comm)
! person_in_charge: mathieu.courtois@edf.fr
!
!
    implicit none
#include "asterc/asmpi_comm.h"
#include "asterf_debug.h"
!
    mpi_int, intent(in), optional :: comm
!
!   Set a MPI Barrier on the given communicator or the current one.
!
    mpi_int :: comm2, idummy
#ifdef _USE_MPI
#include "asterc/asmpi_barrier_wrap.h"
    if (.not. present(comm)) then
        call asmpi_comm('GET', comm2)
    else
        comm2 = comm
    endif
!
!   `asmpi_check()` is called from C
    DEBUG_MPI('mpi_barrier', 'communicator', comm2)
    call asmpi_barrier_wrap(comm2, idummy)
#else
    if (.not. present(comm)) then
        comm2 = 0
    else
        comm2 = comm
    endif
    idummy = 0
#endif
end subroutine asmpi_barrier
