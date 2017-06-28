! This file is part of code_aster.
!
! COPYRIGHT (C) 1991 - 2016  EDF R&D                WWW.CODE-ASTER.ORG
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine apalmh(kptsc)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=C1308
use petsc_data_module
    implicit none

#include "jeveux.h"
#include "asterc/loisem.h"
#include "asterfort/apbloc.h"
#include "asterfort/assert.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
    integer :: kptsc
!----------------------------------------------------------------
!
!  CREATION DE LA MATRICE PETSC (INSTANCE NUMERO KPTSC)
!  PREALLOCATION DANS LE CAS GENERAL
!
!----------------------------------------------------------------
!
#ifdef _HAVE_PETSC
!
!     VARIABLES LOCALES
    integer :: nsmdi, nsmhc, ndprop, nz, bs, numpro, iaux, jjoint
    integer :: jsmdi, jsmhc, jidxd, procol, prolig, lgenvo, jvaleu
    integer :: i, k, nzdeb, nzfin, jidxo, jaux
    integer :: jnequ, iligl, jcoll, iligg, jcolg, numloc, numglo
    integer :: rang, nbproc, jprddl, jnugll, nloc, nglo, jidxdc
    integer :: jrefn, nuno1, nucmp1, nuno2, nucmp2, num_ddl_max
    integer :: num_ddl_min, jslvi, tbloc, iret
    character(len=8) :: noma
!
!    integer(kind=4) :: iermpi, lint, lint4, lr8, lc8, n4, iaux4, num4, numpr4
    integer(kind=4) :: mpicou
    mpi_int :: mrank, msize
!
    character(len=19) :: nomat, nosolv
    character(len=16) :: idxo, idxd
    character(len=14) :: nonu
    character(len=4) :: kbid, chnbjo
    character(len=8) :: k8bid
    character(len=24) :: nojoin
!
    parameter   (idxo  ='&&APALMC.IDXO___')
    parameter   (idxd  ='&&APALMC.IDXD___')
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscInt :: low, high, neql, neqg, ierr
    PetscScalar :: xx(1)
    PetscOffset :: xidx
    Mat :: a
!----------------------------------------------------------------
    call jemarq()
!
!   -- COMMUNICATEUR MPI DE TRAVAIL
    call asmpi_comm('GET', mpicou)
!
!     -- LECTURE DU COMMUN
    nomat = nomat_courant
    nonu = nonu_courant
    nosolv = nosols(kptsc)
!
    call jeveuo(nonu//'.SMOS.SMDI', 'L', jsmdi)
    call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
    call jeveuo(nonu//'.SMOS.SMHC', 'L', jsmhc)
    call jelira(nonu//'.SMOS.SMHC', 'LONMAX', nsmhc)
    nz = zi(jsmdi-1+nsmdi)
!
    call apbloc(kptsc)
    bs=tblocs(kptsc)

    ASSERT(bs.ge.1)

!    fictif=fictifs(kptsc)
!    if (fictif.eq.1) then
!        new_ieq => new_ieqs(kptsc)%pi4
!        old_ieq => old_ieqs(kptsc)%pi4
!        ASSERT(size(new_ieq).eq.neq)
!        neq2=size(old_ieq)
!        ASSERT(neq2.gt.neq)
!    else
!        neq2=neq
!        allocate(new_ieq(neq))
!        allocate(old_ieq(neq))
!        do k=1,neq
!            new_ieq(k)=k
!            old_ieq(k)=k
!        enddo
!    endif
    call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
    call jeveuo(nonu//'.NUME.NULG', 'L', jnugll)
    call jeveuo(nonu//'.NUME.PDDL', 'L', jprddl)
    call jeveuo(nonu//'.NUME.REFN', 'L', jrefn)
    noma = zk24(jrefn)
    nloc = zi(jnequ)
    nglo = zi(jnequ+1)
    neqg = nglo
    neql = nloc

!
!     -- RECUPERE LE RANG DU PROCESSUS ET LE NB DE PROCS
    call asmpi_info(rank=mrank, size=msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
    ndprop = 0
!
    num_ddl_max = 0
    num_ddl_min = 999999999
    do jcoll = 1, nloc
        procol = zi(jprddl - 1 + jcoll)
        if (procol .eq. rang) then
            ndprop = ndprop + 1
            num_ddl_max = max(num_ddl_max, zi(jnugll + jcoll -1))
            num_ddl_min = min(num_ddl_min, zi(jnugll + jcoll -1))
        endif
    end do

    call MatCreate(mpicou, a, ierr)
    ASSERT(ierr.eq.0)
    call MatSetSizes(a, to_petsc_int(ndprop), to_petsc_int(ndprop), &
                     to_petsc_int(neqg), to_petsc_int(neqg),&
                     ierr)
    ASSERT(ierr.eq.0)
!
#ifndef ASTER_PETSC_VERSION_LEQ_32
!   AVEC PETSc >= 3.3
!   IL FAUT APPELER MATSETBLOCKSIZE *AVANT* MAT*SETPREALLOCATION
    call MatSetBlockSize(a, to_petsc_int(bs), ierr)
    ASSERT(ierr.eq.0)
#endif

    call MatSetType(a, MATMPIAIJ, ierr)
    ASSERT(ierr.eq.0)
    low=num_ddl_min
    high=num_ddl_max+1
!    call MatGetOwnershipRange(a, low, high, ierr)
!    ASSERT(ierr.eq.0)
    write(6,*)'ndprop, neqg, num_ddl_min', ndprop, neqg, num_ddl_min, num_ddl_max
!
    call wkvect(idxd, 'V V S', ndprop, jidxd)
    call wkvect(idxo, 'V V S', ndprop, jidxo)
!
    jcolg = zi(jnugll)
    if (zi(jprddl) .eq. rang) then
        zi4(jidxd + jcolg - low) = zi4(jidxd + jcolg - low) + 1
! nsellenet 2013-09-27
!        ASSERT( jcolg .ge. low .and. jcolg .lt. high )
! nsellenet 2013-09-27
    endif
!
!   On commence par s'occuper du nombre de NZ par ligne
!   dans le bloc diagonal
    do jcoll = 2, nloc
        nzdeb = zi(jsmdi + jcoll - 2) + 1
        nzfin = zi(jsmdi + jcoll - 1)
        procol = zi(jprddl + jcoll - 1)
        jcolg = zi(jnugll + jcoll - 1)
        do k = nzdeb, nzfin
            iligl = zi4(jsmhc + k - 1)
            prolig = zi(jprddl + iligl - 1)
            iligg = zi(jnugll + iligl - 1)
            if (procol .eq. rang .and. prolig .eq. rang) then
                zi4(jidxd + iligg - low) = zi4(jidxd + iligg - low) + 1
! nsellenet 2013-09-27
!                ASSERT( iligg .ge. low .and. iligg .lt. high )
!                ASSERT( jcolg .ge. low .and. jcolg .lt. high )
! nsellenet 2013-09-27
                if (iligg .ne. jcolg) then
                    zi4(jidxd + jcolg - low) = zi4(jidxd + jcolg - low) + 1
                endif
            else if (procol .ne. rang .and. prolig .eq. rang) then
                zi4(jidxo + iligg - low) = zi4(jidxo + iligg - low) + 1
! nsellenet 2013-09-27
!                ASSERT( iligg .ge. low .and. iligg .lt. high )
! nsellenet 2013-09-27
            else if (procol .eq. rang .and. prolig .ne. rang) then
                zi4(jidxo + jcolg - low) = zi4(jidxo + jcolg - low) + 1
! nsellenet 2013-09-27
!                ASSERT( jcolg .ge. low .and. jcolg .lt. high )
! nsellenet 2013-09-27
            endif
        end do
    end do

!    if (nbproc .eq. 1) then
!        call MatSetType(a, MATSEQAIJ, ierr)
!        ASSERT(ierr.eq.0)
!        call MatSEQAIJSetPreallocation(a, PETSC_NULL_INTEGER, zi4( jidxd), ierr)
!        ASSERT(ierr.eq.0)
!    else
        call MatMPIAIJSetPreallocation(a, PETSC_NULL_INTEGER, zi4( jidxd),&
                                       PETSC_NULL_INTEGER, zi4(jidxo), ierr)
        ASSERT(ierr.eq.0)
!    endif
!
#ifdef ASTER_PETSC_VERSION_LEQ_32
!      LE BS DOIT ABSOLUMENT ETRE DEFINI ICI
    call MatSetBlockSize(a, to_petsc_int(bs), ierr)
    ASSERT(ierr.eq.0)
!   RQ : A PARTIR DE LA VERSION V 3.3 IL DOIT PRECEDER LA PREALLOCATION
#endif
!
    ap(kptsc)=a


    1000 format(i6,' ',i6,' ',i6,' ',i6,' ',i6,' ',i6,' ',1pe20.13)
!
    call jedetr(idxd)
    call jedetr(idxo)
!
    call jedema()
!
#else
    integer :: idummy
    idummy = kptsc
#endif
!
end subroutine
