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
!
subroutine crnulg(numddl)
    implicit none
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/crnlgc.h"
#include "asterfort/crnlgn.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jemarq.h"
#include "asterfort/asmpi_info.h"
#include "asterc/asmpi_comm.h"
    character(len=14) :: numddl
!
#ifdef _USE_MPI
#include "mpif.h"
!
    integer :: rang, nbproc
    mpi_int :: mrank, msize, mpicou
!
!----------------------------------------------------------------------
    call jemarq()
!
    call asmpi_comm('GET', mpicou)
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    ASSERT(nbproc.lt.9999)

!   Création de la numérotation
    call crnlgn(numddl)

!   Communication de la numérotation
    call crnlgc(numddl)

!   Suppression des objets temporaires
    call jedetc('V', '&&CRNULG', 1)
!
    call jedema()
#endif
!
end subroutine
