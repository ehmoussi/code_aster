subroutine cpysol(numddl, rsolu, debglo, vecpet, nbval)
    implicit none
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterc/loisem.h"
#include "asterfort/wkvect.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/asmpi_info.h"
#include "asterc/asmpi_recv_r.h"
#include "asterc/asmpi_send_r.h"
    integer(kind=4) :: debglo, nbval
    real(kind=8) :: rsolu(*), vecpet(*)
    character(len=14) :: numddl
#ifdef _USE_MPI
#include "mpif.h"
!
    integer :: rang, nbproc, jnbjoi, nbjoin, numpro, jjointr, jjointe
    integer :: lgenvo, lgrecep, jvaleue, jvaleur, iaux, jaux, jnulg, jprddl, jnequ, nloc
    integer :: numglo, jdeeq, jrefn, jmlogl, nuno1, nucmp1, numloc
!
!    integer(kind=4) :: iermpi, lint, lint4, lr8, lc8
    integer(kind=4) :: n4r, n4e, iaux4, num4, numpr4
    mpi_int :: mrank, msize, iermpi, mpicou
    mpi_int :: lr8, lint, lint4, nbv4, nbpro4, nudes4, numes4
!
    character(len=4) :: chnbjo
    character(len=8) :: k8bid, noma
    character(len=24) :: nonbjo, nojoinr, nojoine, nonulg
!
!    logical :: first
!    save         first,lint,lint4,lr8,lc8
!    data         first /.true./
!----------------------------------------------------------------------
!
    call jemarq()
!
    call asmpi_comm('GET', mpicou)
    if (loisem() .eq. 8) then
        lint=MPI_INTEGER8
    else
        lint=MPI_INTEGER
    endif
    lint4=MPI_INTEGER4
    lr8 = MPI_DOUBLE_PRECISION
!
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
    nonbjo = numddl//'.NUME.NBJO'
    call jeveuo(nonbjo, 'L', jnbjoi)
    nbjoin = zi(jnbjoi)
!
    call jeveuo(numddl//'.NUME.NULG', 'L', jnulg)
    call jeveuo(numddl//'.NUME.PDDL', 'L', jprddl)
    call jeveuo(numddl//'.NUME.NEQU', 'L', jnequ)
    nloc = zi(jnequ)
!
    do iaux = 0, nloc
        if (zi(jprddl + iaux) .eq. rang) then
            numglo = zi(jnulg + iaux)
            rsolu(iaux + 1) = vecpet(numglo - debglo + 1)
        endif
    enddo
!
    do iaux = 0, nbjoin - 1
        numpro = zi(jnbjoi + iaux + 1)
        if (numpro .ne. -1) then
            call codent(iaux, 'G', chnbjo)
!
            nojoinr = numddl//'.NUME.R'//chnbjo(1:3)
            call jeveuo(nojoinr, 'L', jjointr)
            call jelira(nojoinr, 'LONMAX', lgrecep, k8bid)
            nojoine = numddl//'.NUME.E'//chnbjo(1:3)
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
!                call MPI_SEND(zr(jvaleue), n4e, lr8, numpr4, num4,&
!                              MPI_COMM_WORLD, iermpi)
!                call MPI_RECV(zr(jvaleur), n4r, lr8, numpr4, num4,&
!                              MPI_COMM_WORLD, MPI_STATUS_IGNORE, iermpi)
                call asmpi_send_r(zr(jvaleue), n4e, numpr4, num4,&
                                  mpicou)
                call asmpi_recv_r(zr(jvaleur), n4r, numpr4, num4,&
                                  mpicou)
            else if (rang.gt.numpro) then
!                call MPI_RECV(zr(jvaleur), n4r, lr8, numpr4, num4,&
!                              MPI_COMM_WORLD, MPI_STATUS_IGNORE, iermpi)
!                call MPI_SEND(zr(jvaleue), n4e, lr8, numpr4, num4,&
!                              MPI_COMM_WORLD, iermpi)
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
! nsellenet
!     call jeveuo(numddl//'.NUME.DEEQ', 'L', jdeeq)
!     call jeveuo(numddl//'.NUME.REFN', 'L', jrefn)
!     noma = zk24(jrefn)
!     nonulg = noma//'.NULOGL'
!     call jeveuo(nonulg, 'L', jmlogl)
!     do iaux = 1, nloc
!         if ( zi(jprddl + iaux - 1) .eq. rang ) then
!             nuno1 = zi(jmlogl + zi(jdeeq + (iaux - 1) * 2) - 1)
!             nucmp1 = zi(jdeeq + (iaux - 1) * 2 + 1)
!             write(19,*) zi(jnulg + iaux - 1), rsolu(iaux)
!        endif
!      enddo
! nsellenet
    call jedema()
#endif
!
end subroutine
