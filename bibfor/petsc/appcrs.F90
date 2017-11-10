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

subroutine appcrs(kptsc, lmd)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=
use aster_petsc_module
use petsc_data_module
    implicit none

#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/crsmsp.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: kptsc
    aster_logical :: lmd
!----------------------------------------------------------------
!
!  CREATION DU PRECONDITIONNEUR PETSC (INSTANCE NUMERO KPTSC)
!  PHASE DE RESOLUTION (RESOUD)
!
!----------------------------------------------------------------
!
#ifdef _HAVE_PETSC
#include "asterfort/ldsp1.h"
#include "asterfort/ldsp2.h"
!----------------------------------------------------------------
!
!     VARIABLES LOCALES
    integer :: rang, nbproc
    integer :: jslvk, jslvr, jslvi, jnequ, jnequl, jprddl, jcoll, nloc
    integer :: niremp, nsmdi
    mpi_int :: mpicou
!
    character(len=24) :: precon
    character(len=19) :: nomat, nosolv
    character(len=14) :: nonu
!
    real(kind=8) :: fillin
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscErrorCode ::  ierr
    integer :: fill, neq, ndprop
    PetscReal :: fillp
    Mat :: a
    KSP :: ksp, kspp
    PC :: pc, pcp
    mpi_int :: mrank, msize
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
    a = ap(kptsc)
    ksp = kp(kptsc)
!
    call jeveuo(nosolv//'.SLVK', 'L', jslvk)
    call jeveuo(nosolv//'.SLVR', 'L', jslvr)
    call jeveuo(nosolv//'.SLVI', 'L', jslvi)
    precon = zk24(jslvk-1+2)
    fillin = zr(jslvr-1+3)
    niremp = zi(jslvi-1+4)
!
    fill = niremp
    fillp = fillin
!
!     -- RECUPERE LE RANG DU PROCESSUS ET LE NB DE PROCS
    call asmpi_info(rank=mrank, size=msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
!     -- CAS PARTICULIER (LDLT_INC/SOR)
!     -- CES PC NE SONT PAS PARALLELISES
!     -- ON UTILISE DONC DES VERSIONS PAR BLOC
!     ----------------------------------------
    if ((precon.eq.'LDLT_INC') .or. (precon.eq.'SOR')) then
        if (nbproc .gt. 1) then
            kspp=ksp
            call KSPGetPC(kspp, pcp, ierr)
            ASSERT(ierr.eq.0)
            call PCSetType(pcp, PCBJACOBI, ierr)
            ASSERT(ierr.eq.0)
            call KSPSetUp(kspp, ierr)
            ASSERT(ierr.eq.0)
            call PCBJacobiGetSubKSP(pcp, PETSC_NULL_INTEGER, PETSC_NULL_INTEGER, ksp, ierr)
            ASSERT(ierr.eq.0)
        else
            goto 999
        endif
    endif
!
!     -- choix du preconditionneur :
!     -------------------------------
    call KSPGetPC(ksp, pc, ierr)
    ASSERT(ierr.eq.0)
!-----------------------------------------------------------------------
    if (precon .eq. 'LDLT_INC') then
        call PCSetType(pc, PCILU, ierr)
        ASSERT(ierr.eq.0)
        call PCFactorSetLevels(pc, to_petsc_int(fill), ierr)
        ASSERT(ierr.eq.0)
        call PCFactorSetFill(pc, fillp, ierr)
        ASSERT(ierr.eq.0)
        call PCFactorSetMatOrderingType(pc, MATORDERINGNATURAL, ierr)
        ASSERT(ierr.eq.0)
!-----------------------------------------------------------------------
    else if (precon.eq.'LDLT_SP') then
!        CREATION SOLVEUR BIDON SIMPLE PRECISION
        spsomu = zk24(jslvk-1+3)(1:19)
        call crsmsp(spsomu, nomat, 0, 'IN_CORE')
!        CREATION DES VECTEURS TEMPORAIRES UTILISES DANS LDLT_SP
        if (lmd) then
            call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
            call jeveuo(nonu//'.NUML.NEQU', 'L', jnequl)
            call jeveuo(nonu//'.NUML.PDDL', 'L', jprddl)
            nloc=zi(jnequl)
            neq=zi(jnequ)
            ndprop = 0
            do jcoll = 0, nloc-1
                if (zi(jprddl+jcoll) .eq. rang) ndprop = ndprop+1
            end do
!
#if PETSC_VERSION_LT(3,8,0) 
            ASSERT( xlocal == PETSC_NULL_OBJECT )
#else
            ASSERT( xlocal == PETSC_NULL_VEC )
#endif 
            call VecCreateMPI(mpicou, to_petsc_int(ndprop), to_petsc_int(neq), xlocal, ierr)
        else
            call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
            neq=nsmdi
!
!
#if PETSC_VERSION_LT(3,8,0) 
            ASSERT( xlocal == PETSC_NULL_OBJECT )
#else
            ASSERT( xlocal == PETSC_NULL_VEC )
#endif 
            call VecCreateMPI(mpicou, PETSC_DECIDE, to_petsc_int(neq), xlocal, ierr)
        endif
        ASSERT(ierr.eq.0)
!
#if PETSC_VERSION_LT(3,8,0) 
            ASSERT( xscatt == PETSC_NULL_OBJECT )
#else
            ASSERT( xscatt == PETSC_NULL_VECSCATTER )
#endif 
#if PETSC_VERSION_LT(3,8,0) 
            ASSERT( xglobal == PETSC_NULL_OBJECT )
#else
            ASSERT( xglobal == PETSC_NULL_VEC )
#endif
#if PETSC_VERSION_LT(3,8,0) 
#else
! Ne pas supprimer VecCreate: si xglobal vaut PETSC_NULL_VEC en entrée de VecScatterCreateToAll,
! il n'est pas alloué en sortie 
        call VecCreate( mpicou, xglobal, ierr )
        ASSERT( ierr == 0 )
#endif
        call VecScatterCreateToAll(xlocal, xscatt, xglobal, ierr)
        ASSERT(ierr.eq.0)
!-----------------------------------------------------------------------
    else if (precon.eq.'SOR') then
        call PCSetType(pc, PCSOR, ierr)
        ASSERT(ierr.eq.0)
    endif
!-----------------------------------------------------------------------
!
!     CREATION EFFECTIVE DES PRECONDITIONNEURS RETARDES
    if ((precon.eq.'LDLT_INC') .or. (precon.eq.'SOR')) then
        call PCSetUp(pc, ierr)
        if (ierr .ne. 0) then
            call utmess('F', 'PETSC_14')
        endif
    endif
!
999 continue
!
    call jedema()
!
#else
    integer :: idummy
    aster_logical :: ldummy
    idummy = kptsc
    ldummy = lmd
#endif
!
end subroutine
