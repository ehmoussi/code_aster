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

subroutine ghost_cells_communication(numddl, rsolu)
! person_in_charge: nicolas.sellenet@edf.fr
    implicit none
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterc/asmpi_comm.h"
#include "asterc/asmpi_recv_r.h"
#include "asterc/asmpi_send_r.h"
    real(kind=8) :: rsolu(*)
    character(len=14) :: numddl
#ifdef _USE_MPI
!
    integer :: rang, nbproc, jnbjoi, nbjoin, numpro, jjointr, jjointe
    integer :: lgenvo, lgrecep, jvaleue, jvaleur, iaux, jaux, jprddl
    integer :: jrefn, numloc
!
    integer(kind=4) :: n4r, n4e, num4, numpr4
    mpi_int :: mrank, msize, mpicou
!
    character(len=4) :: chnbjo
    character(len=8) :: k8bid
    character(len=24) :: nonbjo, nojoinr, nojoine
!----------------------------------------------------------------------
!
    call jemarq()
!
    call asmpi_comm('GET', mpicou)
!
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
    nonbjo = numddl//'.NUME.NBJO'
    call jeveuo(nonbjo, 'L', jnbjoi)
    nbjoin = zi(jnbjoi)
!
    call jeveuo(numddl//'.NUME.PDDL', 'L', jprddl)
!
    do iaux = 0, nbjoin - 1
        numpro = zi(jnbjoi + iaux + 1)
        if (numpro .ne. -1) then
            call codent(iaux, 'G', chnbjo)
!
            nojoinr = numddl//'.NUMER'//chnbjo(1:3)
            call jeveuo(nojoinr, 'L', jjointr)
            call jelira(nojoinr, 'LONMAX', lgrecep, k8bid)
            nojoine = numddl//'.NUMEE'//chnbjo(1:3)
            call jeveuo(nojoine, 'L', jjointe)
            call jelira(nojoine, 'LONMAX', lgenvo, k8bid)
            ASSERT(lgenvo .gt. 0 .and. lgrecep .gt. 0)
!
            call wkvect('&&CPYSOL.TMP1E', 'V V R', lgenvo, jvaleue)
            call wkvect('&&CPYSOL.TMP1R', 'V V R', lgrecep, jvaleur)
            do jaux = 0, lgenvo - 1
                numloc = zi(jjointe + jaux)
                ASSERT(zi(jprddl + numloc - 1) .eq. rang)
                zr(jvaleue + jaux) = rsolu(numloc)
            enddo
!
            n4e = lgenvo
            n4r = lgrecep
            num4 = iaux
            numpr4 = numpro
            if (rang .lt. numpro) then
                call asmpi_send_r(zr(jvaleue), n4e, numpr4, num4,&
                                  mpicou)
                call asmpi_recv_r(zr(jvaleur), n4r, numpr4, num4,&
                                  mpicou)
            else if (rang.gt.numpro) then
                call asmpi_recv_r(zr(jvaleur), n4r, numpr4, num4,&
                                  mpicou)
                call asmpi_send_r(zr(jvaleue), n4e, numpr4, num4,&
                                  mpicou)
            else
                ASSERT(.false.)
            endif
            do jaux = 0, lgrecep - 1
                numloc = zi(jjointr + jaux)
                ASSERT(zi(jprddl + numloc - 1) .eq. numpro)
                rsolu(numloc) = zr(jvaleur + jaux)
            enddo
            call jedetr('&&CPYSOL.TMP1E')
            call jedetr('&&CPYSOL.TMP1R')
        endif
    enddo
    call jedema()
#endif
!
end subroutine ghost_cells_communication
