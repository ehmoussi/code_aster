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

subroutine ap_assembly_vector(chno)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
! person_in_charge: nicolas.sellenet at edf.fr
use aster_petsc_module
use petsc_data_module
use saddle_point_module, only : convert_rhs_to_saddle_point

    implicit none

#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/ap_on_off.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/gettco.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*), intent(in) :: chno
!----------------------------------------------------------------
!
!  Le but de cette routine est de completer un vecteur
!  parallele distribue (assemblage parallele)
!
!----------------------------------------------------------------
#ifdef _HAVE_PETSC
!
!     VARIABLES LOCALES
    integer :: rang, nbproc, jnequ, numglo, jnulg
    integer :: iloc, nloc, nglo, ndprop, nval, jvale
    integer, dimension(:), pointer         :: pddl => null()
    integer(kind=4), dimension(:), pointer :: ig_petsc_c => null()
    real(kind=8) :: value

    mpi_int :: mpicomm
!
    character(len=14) :: numddl

    real(kind=8), dimension(:), pointer :: val => null()
    character(len=16) :: typsd
    character(len=19) :: cn19, pfchno, nommai
    aster_logical :: petscInit
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscErrorCode :: ierr
    mpi_int :: mrank, msize
    Vec :: assembly
    PetscInt :: low, high
    PetscScalar :: xx(1)
    PetscOffset :: xidx
    PetscBool :: done
!----------------------------------------------------------------
    call jemarq()
!
    cn19=chno
    typsd='****'

    call dismoi('PROF_CHNO',cn19,'CHAM_NO', repk=pfchno)
    ASSERT(pfchno(15:19).eq.'.NUME')
    numddl=pfchno(1:14)
    call dismoi('NOM_MAILLA', numddl, 'NUME_DDL', repk=nommai)
    call gettco(nommai(1:8), typsd)
    if( typsd.ne.'MAILLAGE_P' ) then
        goto 9999
    endif
    call jeveuo(numddl//'.NUME.NULG', 'L', jnulg)
    call jeveuo(numddl//'.NUME.PDDL', 'L', vi=pddl)
    call jeveuo(numddl//'.NUME.NEQU', 'L', jnequ)
    call jeveuo(cn19//'.VALE', 'E', jvale)
    nloc = zi(jnequ)
    nglo = zi(jnequ+1)
!
!   -- COMMUNICATEUR MPI DE TRAVAIL
    call asmpi_comm('GET', mpicomm)
!
    call asmpi_info(rank=mrank, size=msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!   Nombre de ddls m'appartenant (pour PETSc)
    ndprop = count( pddl(1:nloc) == rang )
!
    call PetscInitialized(done, ierr)
    ASSERT(ierr.eq.0)
    if( .not.done ) then
        call ap_on_off('ON')
    endif
    call VecCreate(mpicomm, assembly, ierr)
    ASSERT(ierr.eq.0)
    call VecSetSizes(assembly, to_petsc_int(ndprop), to_petsc_int(nglo), ierr)
    ASSERT(ierr.eq.0)
    call VecSetType(assembly, VECMPI, ierr)
    ASSERT(ierr.eq.0)
!
    AS_ALLOCATE( vi4=ig_petsc_c, size=nloc )
    AS_ALLOCATE( vr=val, size=nloc )
    nval = 0
    do iloc = 1, nloc
        value = zr(jvale+iloc-1)
        if( value.ne.0.d0 ) then
            nval = nval+1
            ig_petsc_c(nval) = zi(jnulg+iloc-1)
            val(nval) = value
        endif
    end do
    call VecSetValues(assembly, to_petsc_int(nval), ig_petsc_c, val, ADD_VALUES, ierr)
    ASSERT(ierr.eq.0)
    call VecAssemblyBegin(assembly, ierr)
    ASSERT(ierr.eq.0)
    call VecAssemblyEnd(assembly, ierr)
    ASSERT(ierr.eq.0)
!
    call VecGetOwnershipRange(assembly, low, high, ierr)
    ASSERT(ierr.eq.0)
!
    call VecGetArray(assembly, xx, xidx, ierr)
    ASSERT(ierr.eq.0)
    do iloc = 0, nloc-1
        if( pddl(iloc+1) .eq. rang ) then
            numglo = zi(jnulg+iloc)
            zr(jvale+iloc) = xx(xidx+numglo-low+1)
        endif
    enddo
!
    call VecRestoreArray(assembly, xx, xidx, ierr)
    ASSERT(ierr.eq.0)
    AS_DEALLOCATE(vi4=ig_petsc_c)
    AS_DEALLOCATE(vr=val)
    call VecDestroy(assembly, ierr)
    ASSERT(ierr.eq.0)
!
9999 continue
    call jedema()
!
#else
    integer :: idummy
    aster_logical :: ldummy
    real(kind=8) :: rdummy
#endif
!
end subroutine
