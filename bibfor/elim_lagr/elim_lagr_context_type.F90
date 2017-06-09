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

module elim_lagr_context_type
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
!
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=W1304,W1003
!
implicit none
!
private
#include "asterf.h"
#include "asterfort/assert.h"
!
!----------------------------------------------------------------------
! Container regroupant toutes les matrices et tous les vecteurs (PETSc)
! nécessaires à la fonctionnalité ELIM_LAGR='OUI' (pour une matrice Aster)
! Ce type contient un pointeur vers un objet de type saddle_point_context
!----------------------------------------------------------------------

type, public ::  elim_lagr_ctxt
!
#ifdef _HAVE_PETSC
    Mat :: kproj
    Mat :: ctrans
    Mat :: tfinal
    Mat :: rct
    Mat :: matb
    Vec :: vx0
    Vec :: vecb
    Vec :: vecc
    integer :: nphys
    integer :: nlag
    integer(kind=4), dimension(:), pointer :: indred
    ! nom de la matrice Aster "complète" (avec Lagranges)
    character(len=19) :: full_matas
    ! nom de la matrice Aster "réduite" (sans Lagranges)
    character(len=19) :: reduced_matas
    ! nom de la matrice de rigidité Aster contenant les
    ! relations lineaires
    ! c'est utile dans le cas ou on reduit une matrice de masse
    ! ou d'amortissement qui ne contient pas ces relations lineaires
    ! il faut alors utiliser la matrice de rigidite du systeme
    character(len=19) ::  k_matas
#else
    integer :: idummy
#endif
end type elim_lagr_ctxt
!
public :: new_elim_lagr_context, free_elim_lagr_context
!
#ifdef _HAVE_PETSC
PetscErrorCode, private :: ierr
!
contains
!
! Returns a fresh elim_lagr_context
!
function new_elim_lagr_context() result ( elg_ctxt )
  !
  type(elim_lagr_ctxt) :: elg_ctxt
  !
  elg_ctxt%full_matas=' '
  elg_ctxt%reduced_matas=' '
  elg_ctxt%k_matas=' '
  elg_ctxt%kproj=0
  elg_ctxt%ctrans=0
  elg_ctxt%tfinal=0
  elg_ctxt%rct=0
  elg_ctxt%matb=0
  elg_ctxt%vx0=0
  elg_ctxt%vecb=0
  elg_ctxt%vecc=0
  nullify(elg_ctxt%indred)
  !
end function new_elim_lagr_context
!
!
! Free object elg_ctxt
!
subroutine free_elim_lagr_context( elg_ctxt )
!   Dummy argument
    type(elim_lagr_ctxt), intent(inout) :: elg_ctxt
!
    elg_ctxt%full_matas=' '
    elg_ctxt%reduced_matas=' '
    elg_ctxt%k_matas=' '
!
    call MatDestroy(elg_ctxt%kproj, ierr)
    ASSERT( ierr == 0 )
    call MatDestroy(elg_ctxt%ctrans, ierr)
    ASSERT( ierr == 0 )
    call MatDestroy(elg_ctxt%tfinal, ierr)
    ASSERT( ierr == 0 )
    call MatDestroy(elg_ctxt%rct, ierr)
    ASSERT( ierr == 0 )
    call MatDestroy(elg_ctxt%matb, ierr)
    ASSERT( ierr == 0 )
    call VecDestroy(elg_ctxt%vx0, ierr)
    ASSERT( ierr == 0 )
    call VecDestroy(elg_ctxt%vecb, ierr)
    ASSERT( ierr == 0 )
    call VecDestroy(elg_ctxt%vecc, ierr)
    ASSERT( ierr == 0 )
    if (associated(elg_ctxt%indred)) then
    deallocate(elg_ctxt%indred)
        nullify(elg_ctxt%indred)
    endif
    elg_ctxt%kproj=0
    elg_ctxt%ctrans=0
    elg_ctxt%tfinal=0
    elg_ctxt%rct=0
    elg_ctxt%matb=0
    elg_ctxt%vx0=0
    elg_ctxt%vecb=0
    elg_ctxt%vecc=0
!
end subroutine free_elim_lagr_context
!
!
#else
! Si on ne compile pas avec PETSc, il faut quand même définir les
! interfaces des routines publiques
contains
!
function new_elim_lagr_context() result ( elg_ctxt )
    type(elim_lagr_ctxt) :: elg_ctxt
    elg_ctxt%idummy = 0
    ASSERT( .false. )
end function new_elim_lagr_context
!
subroutine free_elim_lagr_context( elg_ctxt )
    type(elim_lagr_ctxt), intent(inout) :: elg_ctxt
    elg_ctxt%idummy = 0
end subroutine free_elim_lagr_context

#endif

end module elim_lagr_context_type
