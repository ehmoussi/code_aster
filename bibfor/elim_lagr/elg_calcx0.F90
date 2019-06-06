! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine elg_calcx0()
#include "asterf_types.h"
#include "asterf_petsc.h"
!
use aster_petsc_module
use elg_data_module
    implicit none
! person_in_charge: natacha.bereux at edf.fr
#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
!----------------------------------------------------------------
!
!     Résolution de x0 = A \ c
!     ========================
!     On suppose que le système est sous-déterminé
!     On calcule x0 comme le vecteur de norme minimale vérifiant la
!     contrainte A*x0 = c (i.e. x0 est solution du problème de minimisation
!     sous contrainte : min ||x||, Ax = c )
!     On procède en 3 étapes :
!     * calcul et factorisation de A A' (lors de la construction du elg_context)
!     * résolution de y0 = ( A A' ) \ c 
!     * calcul de x0 = A' * y0
!
!     * Vec VecC (second membre c)
!       VecC utilisé est ELIMLG/VecC
!     * Vec Vx0  (solution)
!       Vx0 utilisé est ELIMLG/Vx0
!----------------------------------------------------------------
#ifdef _HAVE_PETSC
    Vec :: vy, y0
    integer :: ifm, niv
    mpi_int :: mpicomm, rang, nbproc
    PetscInt :: its, reason
    PetscErrorCode :: ierr
    PetscInt :: mm, nn
    real(kind=8) :: norm
    PetscScalar, parameter ::  neg_rone = -1.d0
    aster_logical :: info, debug = .false.
!----------------------------------------------------------------
    call jemarq()
    call infniv(ifm, niv)
    info=niv.eq.2
    !
!   -- COMMUNICATEUR MPI DE TRAVAIL
    call asmpi_comm('GET_WORLD', mpicomm)
    call asmpi_info(rank=rang, size=nbproc)
!
!   -- Le système est-il bien sous-déterminé ?
    call MatGetSize( elg_context(ke)%matc, nn, mm , ierr)
    ASSERT( ierr == 0 )
    ASSERT( mm > nn )
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!                      Solve the linear system
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

!
!    y0 = ( A * A' )  \ c
!
    call VecDuplicate( elg_context(ke)%vecc, y0, ierr)
    ASSERT( ierr == 0 )
    call KSPSolve( elg_context(ke)%ksp, elg_context(ke)%vecc, y0, ierr)
    ASSERT( ierr == 0 )
!
!  Check the reason why KSP solver ended
    call KSPGetConvergedReason(elg_context(ke)%ksp, reason, ierr)
    ASSERT( ierr == 0 )
!  Reason < 0 indicates a problem during the resolution
    if (reason<0) then
      call utmess('F','ELIMLAGR_8')
    endif
!
!   x0 = A' * y0
    call MatMultTranspose( elg_context(ke)%matc, y0, elg_context(ke)%vx0, ierr)
    ASSERT( ierr == 0 )
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!                     Check solution and clean up
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

!  Check the error ||A*x0 - c||
!
      if (info) then
      call VecDuplicate(elg_context(ke)%vecc ,vy,ierr)
      ASSERT( ierr == 0 )
      call MatMult(elg_context(ke)%matc,  elg_context(ke)%vx0, vy, ierr)
      ASSERT( ierr == 0 )
      call VecAXPY(vy,neg_rone,elg_context(ke)%vecc ,ierr)
      ASSERT( ierr == 0 )
      call VecNorm(vy,norm_2,norm,ierr)
      ASSERT( ierr == 0 )
      call KSPGetIterationNumber(elg_context(ke)%ksp,its,ierr)
      ASSERT( ierr == 0 )

      if (debug.and.rang==0) then
           write(6,100) norm,its
      endif
  100 format('  ELG CALCX0: Norm of error = ',e11.4,', iterations = ',i5)
      call VecDestroy(vy,ierr)
      ASSERT( ierr == 0 )
      endif
!
!  Free work space.  All PETSc objects should be destroyed when they
!  are no longer needed.

      call VecDestroy(y0, ierr)
      ASSERT( ierr == 0 )
!
    call jedema()
!
#else
    ASSERT(.false.)
#endif
!
end subroutine
