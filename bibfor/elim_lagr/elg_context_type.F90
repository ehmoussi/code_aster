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

module elg_context_type
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
!
use aster_petsc_module
!
implicit none
!
private
#include "asterf.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
!----------------------------------------------------------------------
! Container regroupant toutes les matrices et tous les vecteurs (PETSc)
! nécessaires à la fonctionnalité ELIM_LAGR='OUI' (pour une matrice Aster)
!----------------------------------------------------------------------

type, public ::  elim_lagr_ctxt
!
#ifdef _HAVE_PETSC
! Projection de la matrice B sur le noyau de la matrice
! des contraintes C
! Kproj = tTfinal B Tfinal 
    Mat :: kproj
! Matrice des contraintes
    Mat :: matc
! Matrice contenant la base du noyau de la matrice des contraintes
    Mat :: tfinal
! Matrice initiale B (c'est la matr_asse convertie au format PETSc) 
    Mat :: matb
    Vec :: vx0
    Vec :: vecb
    Vec :: vecc
    integer :: nphys
    integer :: nlag
! Nom de la matrice Aster initiale (avec Lagranges)
    character(len=19) :: full_matas
! Nom de la matrice Aster "réduite" (sans Lagranges)
    character(len=19) :: reduced_matas
! Nom de la matrice de rigidité Aster contenant les
! relations lineaires
! c'est utile dans le cas ou on reduit une matrice de masse
! ou d'amortissement qui ne contient pas ces relations lineaires
! il faut alors utiliser la matrice de rigidite du systeme
    character(len=19) ::  k_matas
#else
#endif
end type elim_lagr_ctxt
!
public :: new_elg_context, free_elg_context
!
#ifdef _HAVE_PETSC
PetscErrorCode  :: ierr
!
contains
!
! Returns a fresh elg_context
!
function new_elg_context() result ( elg_ctxt )
  !
  type(elim_lagr_ctxt) :: elg_ctxt
  !
  elg_ctxt%full_matas=' '
  elg_ctxt%reduced_matas=' '
  elg_ctxt%k_matas=' '
#if PETSC_VERSION_LT(3,8,0)
  elg_ctxt%kproj=PETSC_NULL_OBJECT
  elg_ctxt%matc=PETSC_NULL_OBJECT
  elg_ctxt%tfinal=PETSC_NULL_OBJECT
  elg_ctxt%matb=PETSC_NULL_OBJECT
  elg_ctxt%vx0=PETSC_NULL_OBJECT
  elg_ctxt%vecb=PETSC_NULL_OBJECT
  elg_ctxt%vecc=PETSC_NULL_OBJECT
#else
  elg_ctxt%kproj=PETSC_NULL_MAT
  elg_ctxt%matc=PETSC_NULL_MAT
  elg_ctxt%tfinal=PETSC_NULL_MAT
  elg_ctxt%matb=PETSC_NULL_MAT
  elg_ctxt%vx0=PETSC_NULL_VEC
  elg_ctxt%vecb=PETSC_NULL_VEC
  elg_ctxt%vecc=PETSC_NULL_VEC
#endif
end function new_elg_context
!
!
! Free object elg_ctxt
!
subroutine free_elg_context( elg_ctxt )
!   Dummy argument
    type(elim_lagr_ctxt), intent(inout) :: elg_ctxt
!
    elg_ctxt%full_matas=' '
    elg_ctxt%reduced_matas=' '
    elg_ctxt%k_matas=' '
!
    call MatDestroy(elg_ctxt%kproj, ierr)
    ASSERT( ierr == 0 )
    call MatDestroy(elg_ctxt%matc, ierr)
    ASSERT( ierr == 0 )
    call MatDestroy(elg_ctxt%tfinal, ierr)
    ASSERT( ierr == 0 )
    call MatDestroy(elg_ctxt%matb, ierr)
    ASSERT( ierr == 0 )
    call VecDestroy(elg_ctxt%vx0, ierr)
    ASSERT( ierr == 0 )
    call VecDestroy(elg_ctxt%vecb, ierr)
    ASSERT( ierr == 0 )
    call VecDestroy(elg_ctxt%vecc, ierr)
    ASSERT( ierr == 0 )
!
#if PETSC_VERSION_LT(3,8,0)
  elg_ctxt%kproj=PETSC_NULL_OBJECT
  elg_ctxt%matc=PETSC_NULL_OBJECT
  elg_ctxt%tfinal=PETSC_NULL_OBJECT
  elg_ctxt%matb=PETSC_NULL_OBJECT
  elg_ctxt%vx0=PETSC_NULL_OBJECT
  elg_ctxt%vecb=PETSC_NULL_OBJECT
  elg_ctxt%vecc=PETSC_NULL_OBJECT
#else
  elg_ctxt%kproj=PETSC_NULL_MAT
  elg_ctxt%matc=PETSC_NULL_MAT
  elg_ctxt%tfinal=PETSC_NULL_MAT
  elg_ctxt%matb=PETSC_NULL_MAT
  elg_ctxt%vx0=PETSC_NULL_VEC
  elg_ctxt%vecb=PETSC_NULL_VEC
  elg_ctxt%vecc=PETSC_NULL_VEC
#endif
!
end subroutine free_elg_context
!
!
#else
! Si on ne compile pas avec PETSc, il faut quand même définir les
! interfaces des routines publiques
contains
!
function new_elg_context() result ( elg_ctxt )
    type(elim_lagr_ctxt) :: elg_ctxt
end function new_elg_context
!
subroutine free_elg_context( elg_ctxt )
    type(elim_lagr_ctxt), intent(inout) :: elg_ctxt
end subroutine free_elg_context
#endif

end module elg_context_type
