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

subroutine extract_nonzero_col(a, acnz, icolnz_c)
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=C1308
#include "asterf_types.h"
#include "asterf_petsc.h"
!
use aster_petsc_module
implicit none
#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
!
!--------------------------------------------------------------
! BUT : creer une matice creuse ACNZ formée des colonnes non-nulles de A
!       A et ACNZ ont le même nombre de termes non-nuls
! RQ : on se base sur la norme des colonnes pour sélectionner les colonnes
!      à garder
!
! IN : A de taille ma x na
! OUT : ACNZ de taille ma x nacnz
!---------------------------------------------------------------
#ifdef _HAVE_PETSC

    Mat, intent(in)  :: a
    Mat, intent(out) :: acnz
    PetscInt, dimension(:), pointer :: icolnz_c
!
!================================================================
!
!     VARIABLES LOCALES
!
    integer :: ifm, niv
    aster_logical :: verbose
    mpi_int :: mpicomm
    PetscInt :: inz, ii
    PetscInt :: first, step, ma, na, nacnz
    PetscErrorCode :: ierr
    PetscInt, parameter :: ione = 1 , izero = 0
    IS :: isall, isnz
    PetscReal, dimension(:), allocatable :: norms
!----------------------------------------------------------------
   call asmpi_comm('GET_WORLD', mpicomm)
   call infniv(ifm, niv)
   verbose=(niv == 2)
!
    call MatGetSize( a, ma, na, ierr)
    ASSERT(ierr == 0 )
!
    allocate(norms( na ), stat = ierr)
    ASSERT(ierr == 0 )
    call MatGetColumnNorms( a, norm_2, norms, ierr)
     ASSERT( ierr == 0 )
!   -- nombre de colonnes nonnulles dans Atmp
    nacnz = count( norms > r8prem() )
!   -- icolnz :indices C des colonnes non nulles de de A
    allocate( icolnz_c( nacnz), stat = ierr )
    ASSERT( ierr == 0 )
!
    inz = 0
    do ii=1, na
        if ( norms( ii ) > r8prem() ) then
         inz = inz + 1
         icolnz_c( inz ) = ii-1
        endif
    enddo

!
!   -- isnz index set des  colonnes non-nulles de Atmp (et de A)
    call ISCreateGeneral(mpicomm, nacnz, icolnz_c, PETSC_USE_POINTER,&
                         isnz, ierr)
!   -- isall index set de toutes les lignes de Atmp
    call ISCreateStride( mpicomm, ma, izero, ione, isall, ierr )
!   -- extraction des colonnes non-nulles de Atmp => Anz
#if PETSC_VERSION_LT(3,8,0)
    call MatGetSubMatrix( a, isall, isnz , MAT_INITIAL_MATRIX, &
        acnz, ierr)
#else
    call MatCreateSubMatrix( a, isall, isnz , MAT_INITIAL_MATRIX, &
        acnz, ierr)
#endif
!
    if (verbose) then
        call MatGetSize( acnz, ma, nacnz, ierr)
        write(ifm,*) " -- EXTRACTION DES COLONNES NON-NULLES  "
        write(ifm,*) "    EN ENTREE, NB COLONNES: ", na
        write(ifm,*) "    EN SORTIE, NB COLONNES: ", nacnz
    endif
!
! Libération de la mémoire
!
    call ISDestroy(isnz, ierr)
    call ISDestroy(isall, ierr)
    deallocate( norms, stat = ierr )
    ASSERT(ierr == 0 )

#else
    integer, intent(in)  :: a
    integer, intent(out)  :: acnz
    integer, dimension(:), pointer :: icolnz_c
    integer :: idummy
    ASSERT(.false.)
    idummy = a + icolnz_c(1)
    acnz = 0
#endif
!
end subroutine
