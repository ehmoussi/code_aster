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

subroutine apsolu(kptsc, lmd, rsolu)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
!
use aster_petsc_module
use petsc_data_module
use saddle_point_module, only : update_double_lagrange

    implicit none
#include "jeveux.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/mrconl.h"
    integer :: kptsc
    aster_logical :: lmd
    real(kind=8) :: rsolu(*)
!----------------------------------------------------------------
!
!  RECOPIE DE LA SOLUTION
!
!----------------------------------------------------------------
#ifdef _HAVE_PETSC
!
!     VARIABLES LOCALES
    integer :: jnequ, jnequl, jnuglp, jnugl, jprddl, nloc, nglo, rang
    integer :: nbproc, lmat, neq, fictif, bs,ieq,k
    integer :: iloc, iglo
    integer :: jrefn, jdeeq, numno1, nucmp1
    integer, dimension(:), pointer :: nlgp => null(), nulg=> null(), prddl =>null()
    logical :: ldebug
!
    character(len=8)  :: noma
    character(len=14) :: nonu
    character(len=19) :: nomat, nosolv
    character(len=24) :: precon
    character(len=24), dimension(:), pointer :: slvk => null()
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscInt :: i, neqg, neql, nuglpe, high2, low2
    PetscErrorCode ::  ierr
    PetscScalar :: xx(1)
    PetscOffset :: xidx
    VecScatter :: ctx
    Vec :: xgth
    mpi_int :: mrank, msize
!----------------------------------------------------------------
    call jemarq()
    ldebug=.false.
!
!     -- LECTURE DU COMMUN
    nomat = nomat_courant
    nonu = nonu_courant
    nosolv = nosols(kptsc)
    bs = tblocs(kptsc)
!
    call jeveuo(nosolv//'.SLVK', 'L', vk24=slvk)
    precon = slvk(2)
    if ( precon == 'BLOC_LAGR' ) then
            call update_double_lagrange( x )
    endif
!
    call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
    neqg = zi(jnequ)
    !
    if (lmd) then
!
        call asmpi_info(rank=mrank, size=msize)
        rang = to_aster_int(mrank)
        nbproc = to_aster_int(msize)
!
        call jeveuo(nonu//'.NUML.NLGP', 'L', vi=nlgp)
        call jeveuo(nonu//'.NUML.NULG', 'L', vi=nulg)
        call jeveuo(nonu//'.NUML.NEQU', 'L', jnequl)
        call jeveuo(nonu//'.NUML.PDDL', 'L', vi=prddl)


!
        nloc = zi(jnequl)
        nglo = neqg
        neql = nloc
!
        do iloc = 1, nglo
            rsolu(iloc)=0.d0
        enddo
!
        call VecGetOwnershipRange(x, low2, high2, ierr)
        ASSERT(ierr.eq.0)
!
!       -- RECOPIE DE DANS RSOLU
        call VecGetArray(x, xx, xidx, ierr)
        ASSERT(ierr.eq.0)
!
        do iloc = 1, nloc
            if ( prddl(iloc) .eq. rang ) then
                nuglpe= nlgp(iloc)
                iglo= nulg(iloc)
                rsolu(iglo)=xx(xidx+nuglpe-low2)
            endif
        enddo
!
        call asmpi_comm_vect('MPI_SUM', 'R', nbval=nglo, vr=rsolu)
!
        call VecRestoreArray(x, xx, xidx, ierr)
        ASSERT(ierr.eq.0)
!
    else
        call jelira(nonu//'.SMOS.SMDI', 'LONMAX', neq)
        ASSERT(neq.eq.neqg)
!
!       -- RECONSTRUCTION DE LA LA SOLUTION SUR CHAQUE PROC
        call VecScatterCreateToAll(x, ctx, xgth, ierr)
        ASSERT(ierr.eq.0)
        call VecScatterBegin(ctx, x, xgth, INSERT_VALUES, SCATTER_FORWARD,&
                             ierr)
        ASSERT(ierr.eq.0)
        call VecScatterEnd(ctx, x, xgth, INSERT_VALUES, SCATTER_FORWARD,&
                           ierr)
        ASSERT(ierr.eq.0)
        call VecScatterDestroy(ctx, ierr)
        ASSERT(ierr.eq.0)
!
!       -- RECOPIE DE XX DANS RSOLU
        call VecGetArray(xgth, xx, xidx, ierr)
        ASSERT(ierr.eq.0)
!
        do ieq = 1, neq
            rsolu(ieq)=xx(xidx+ieq)
        end do
!
        call VecRestoreArray(xgth, xx, xidx, ierr)
        ASSERT(ierr.eq.0)
!
!       -- NETTOYAGE
        call VecDestroy(xgth, ierr)
        ASSERT(ierr.eq.0)
!
    endif
!
    call jeveuo(nomat//'.&INT', 'L', lmat)
!
!     -- REMISE A L'ECHELLE DES LAGRANGES DANS LA SOLUTION
    call mrconl('MULT', lmat, 0, 'R', rsolu, 1)
!
    if (ldebug) then
        call jeveuo(nonu//'.NUME.REFN', 'L', jrefn)
        noma = zk24(jrefn)
        call jeveuo(nonu//'.NUME.DEEQ', 'L', jdeeq)
        do ieq = 1, neq
            numno1 = zi(jdeeq+2*(ieq-1))
            nucmp1 = zi(jdeeq +2*(ieq-1) + 1)
            write(19,*) numno1, nucmp1, rsolu(ieq)
        end do
        flush(19)
    endif
!
    call jedema()
!
#else
    integer :: idummy
    aster_logical :: ldummy
    real(kind=8) :: rdummy
    idummy = kptsc
    ldummy = lmd
    rdummy = rsolu(1)
#endif
!
end subroutine
