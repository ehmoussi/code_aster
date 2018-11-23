! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine apvsmb(kptsc, lmd, rsolu)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=
use aster_petsc_module
use petsc_data_module
use saddle_point_module, only : convert_rhs_to_saddle_point

    implicit none

#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: kptsc
    aster_logical :: lmd
    real(kind=8) :: rsolu(*)
!----------------------------------------------------------------
!
!  CREATION ET REMPLISSAGE DU SECOND MEMBRE
!
!----------------------------------------------------------------
#ifdef _HAVE_PETSC
!
!     VARIABLES LOCALES
    integer :: nsmdi, rang, nbproc, jnequ, jnequl
    integer :: iloc, iglo, nloc, nglo, ndprop
    integer :: bs, i, neq, ieq
    integer, dimension(:), pointer         :: nulg => null()
    integer, dimension(:), pointer         :: nlgp => null(), pddl => null()
    integer(kind=4), dimension(:), pointer :: ig_petsc_c => null()

    mpi_int :: mpicomm
!
    character(len=14) :: nonu
    character(len=19) :: nomat, nosolv
    character(len=24) :: precon

    real(kind=8), dimension(:), pointer :: val => null()
    character(len=24), dimension(:), pointer :: slvk => null()
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscInt :: low2, high2
    PetscErrorCode ::  ierr
    PetscScalar :: xx(1)
    PetscOffset :: xidx
    mpi_int :: mrank, msize
!----------------------------------------------------------------
    call jemarq()

!
!   -- COMMUNICATEUR MPI DE TRAVAIL
    call asmpi_comm('GET', mpicomm)
!
!     -- LECTURE DU COMMUN
    nomat = nomat_courant
    nonu = nonu_courant
    bs = tblocs(kptsc)
    ASSERT(bs.ge.1)
    nosolv = nosols(kptsc)

!
    call jeveuo(nosolv//'.SLVK', 'L', vk24=slvk)
    precon = slvk(2)
!
    if (lmd) then
        call asmpi_info(rank=mrank, size=msize)
        rang = to_aster_int(mrank)
        nbproc = to_aster_int(msize)
        call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
        call jeveuo(nonu//'.NUML.NEQU', 'L', jnequl)
        call jeveuo(nonu//'.NUML.NULG', 'L', vi=nulg)
        call jeveuo(nonu//'.NUML.NLGP', 'L', vi=nlgp)
        call jeveuo(nonu//'.NUML.PDDL', 'L', vi=pddl)
        nloc = zi(jnequl)
        nglo = zi(jnequ)
!       Nombre de ddls m'appartenant (pour PETSc)
        ndprop = count( pddl(1:nloc) == rang )
!
        call VecCreate(mpicomm, b, ierr)
        ASSERT(ierr.eq.0)
        call VecSetBlockSize(b, to_petsc_int(bs), ierr)
        ASSERT(ierr.eq.0)
        call VecSetSizes(b, to_petsc_int(ndprop), to_petsc_int(nglo), ierr)
        ASSERT(ierr.eq.0)
        call VecSetType(b, VECMPI, ierr)
        ASSERT(ierr.eq.0)
!
        AS_ALLOCATE( vi4=ig_petsc_c, size=nloc )
        AS_ALLOCATE( vr=val, size=nloc )
        do iloc = 1, nloc
            ! Indice global PETSc (convention C)
            ig_petsc_c( iloc ) = nlgp( iloc ) - 1
            ! Indice global Aster (convention F)
            iglo               = nulg( iloc )
            val( iloc )        = rsolu( iglo )
        end do
        call VecSetValues(b, to_petsc_int(nloc), ig_petsc_c, val, ADD_VALUES, ierr)
        call VecAssemblyBegin(b, ierr)
        ASSERT(ierr.eq.0)
        call VecAssemblyEnd(b, ierr)
        ASSERT(ierr.eq.0)
        !
        AS_DEALLOCATE( vi4=ig_petsc_c )
        AS_DEALLOCATE( vr=val )
!
    else
        call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
        neq=nsmdi
        ASSERT(mod(neq,bs).eq.0)
!
!       -- allocation de b :
        call VecCreate(mpicomm, b, ierr)
        ASSERT(ierr.eq.0)
        call VecSetBlockSize(b, to_petsc_int(bs), ierr)
        ASSERT(ierr.eq.0)
        call VecSetSizes(b, PETSC_DECIDE, to_petsc_int(neq), ierr)
        ASSERT(ierr.eq.0)
        call VecSetType(b, VECMPI, ierr)
        ASSERT(ierr.eq.0)
        call VecSet(b, 0.d0, ierr)
        ASSERT(ierr.eq.0)
!
!
!       -- calcul de b=RSOLU :
!       ------------------------------------------------
        call VecGetOwnershipRange(b, low2, high2, ierr)
        call VecGetArray(b, xx, xidx, ierr)
        ASSERT(ierr.eq.0)
!
        do i = 1, high2-low2
            ieq=low2+i
            if (ieq.gt.0) xx(xidx+i)=rsolu(ieq)
        end do
        call VecRestoreArray(b, xx, xidx, ierr)
        ASSERT(ierr.eq.0)
    endif

    if ( precon == 'BLOC_LAGR' ) then
        call convert_rhs_to_saddle_point( b )
    endif


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
