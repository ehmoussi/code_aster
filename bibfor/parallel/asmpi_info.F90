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

subroutine asmpi_info(comm, rank, size)
! person_in_charge: mathieu.courtois@edf.fr
!
!
    implicit none
#include "asterc/asmpi_comm.h"
#include "asterc/asmpi_info_wrap.h"
!
    mpi_int, intent(in), optional :: comm
    mpi_int, intent(out), optional :: rank
    mpi_int, intent(out), optional :: size
!
!   Return the rank of the processor and the number of processors assigned to a communicator.
!   If comm is not provided, use the current communicator.
!
    mpi_int :: comm2, rank2, size2
!
#ifdef _USE_MPI
    if (.not. present(comm)) then
        call asmpi_comm('GET', comm2)
    else
        comm2 = comm
    endif
    call asmpi_info_wrap(comm2, rank2, size2)
#else
    if (.not. present(comm)) then
        comm2 = 0
    else
        comm2 = comm
    endif
    rank2 = 0
    size2 = 1
#endif
    if (present(rank)) then
        rank = rank2
    endif
    if (present(size)) then
        size = size2
    endif
end subroutine asmpi_info
