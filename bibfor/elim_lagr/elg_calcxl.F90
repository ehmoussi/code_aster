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

subroutine elg_calcxl(x1, vlag)
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
#include "asterfort/elg_allocvr.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
!----------------------------------------------------------------
! Calcul des coefficients de Lagrange pour ELIM_LAGR='OUI'
!     IN  : Vec X1    (solution sur les dds physiques)
!
!     OUT : Vec VLAG  (solution sur les dds Lagrange "1")
!
!     On résout  vlag = A'\ Y de la façon suivante :
!       * calcul de CCT = A*A'
!       * calcul de AY = A*Y
!       * résolution (CG) vlag = A*A' \ AY
!
!     Rq: La méthode originale utilise une factorisation QR
!     préalable de A. Le calcul des multiplicateurs s'effectue alors
!     par des descentes remontées:
!      Les coefficients de Lagrange (1 et 2) sont
!     calculés par :
!       L = (R'*R) \ A*(b - B*x)
!----------------------------------------------------------------
!
#ifdef _HAVE_PETSC
!
    Vec :: x1, vlag
!
!================================================================
    mpi_int :: mpicomm, nbproc, rang
    integer :: ifm, niv
    real(kind=8) :: norm
    aster_logical :: info, debug
    PetscInt :: n1, n2, n3
    PetscInt :: reason
    PetscErrorCode :: ierr
    PetscScalar, parameter :: neg_rone=-1.d0
    PetscOffset :: xidxay, xidxl
    Vec :: bx, y, ay, xtmp
    PetscInt :: its
    PetscReal :: aster_petsc_real
    integer :: methode
    integer, parameter :: lsqr=1, cg=2

!----------------------------------------------------------------
    call jemarq()
    call infniv(ifm, niv)
    info=niv.eq.2
    debug = .false.
    !
!   -- COMMUNICATEUR MPI DE TRAVAIL
    call asmpi_comm('GET_WORLD', mpicomm)
    call asmpi_info(rank=rang, size=nbproc)
!
    aster_petsc_real = PETSC_DEFAULT_REAL
!
!     -- dimensions :
!       n1 : # ddls physiques
!       n2 : # lagranges "1"
!     ----------------------------------------------------------
    call MatGetSize(elg_context(ke)%matc, n2, n1, ierr)
!   le système est-il bien  sur-déterminé ?
    ASSERT( n1 > n2 )
!
!     -- vérifs :
    call VecGetSize(x1, n3, ierr)
    ASSERT(n3.eq.n1)
    call VecGetSize(vlag, n3, ierr)
    ASSERT(n3.eq.n2)

!
!
!     -- calcul de BX = B*x :
    call VecDuplicate(x1, bx, ierr)
    ASSERT( ierr==0 )
    call MatMult(elg_context(ke)%matb, x1, bx, ierr)
    ASSERT( ierr==0 )
!
!
!     -- calcul de Y = b - B*x :
    call VecDuplicate(elg_context(ke)%vecb, y, ierr)
    ASSERT( ierr==0 )
    call VecCopy(elg_context(ke)%vecb, y, ierr)
    ASSERT( ierr==0 )
    call VecAXPY(y, neg_rone, bx, ierr)
    ASSERT( ierr==0 )
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!                      Solve the linear system
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
! On résout vlag = A'\ y en 2 étapes
!  * AY = Ay
!  * vlag = A A'\ Ay
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
!   -- Compute AY = A*Y
!
      call elg_allocvr(ay, int(n2))
      call MatMult(elg_context(ke)%matc, y, ay, ierr)
      ASSERT( ierr==0 )
!
!   -- Solve the linear system
      call KSPSolve( elg_context(ke)%ksp, ay, vlag, ierr)
      ASSERT( ierr==0 )
!
!   -- Free memory
      call VecDestroy(ay, ierr)
      ASSERT( ierr==0 )
!
!  Check the reason why KSP solver ended
!
      call KSPGetConvergedReason(elg_context(ke)%ksp, reason, ierr)
      ASSERT( ierr==0 )
    if (reason<0) then
      call utmess('F','ELIMLAGR_8')
    endif
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!                     Check solution and clean up
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!  Check the error ||C^T*vlag - y||
!
    if (info) then
      call VecDuplicate(y, xtmp , ierr)
      ASSERT( ierr==0 )
      call MatMultTranspose(elg_context(ke)%matc, vlag, xtmp, ierr)
      ASSERT( ierr==0 )
      call VecAXPY(xtmp,neg_rone,y ,ierr)
      ASSERT( ierr==0 )
      call VecNorm(xtmp,norm_2,norm,ierr)
      ASSERT( ierr==0 )
      call KSPGetIterationNumber(elg_context(ke)%ksp,its,ierr)
      ASSERT( ierr==0 )

     if (debug .and. rang==0) then
         write(6,100) norm,its
     endif
  100 format(' ELG CALCXL: Norm of error = ',e11.4,',  iterations = ',i5)
      call VecDestroy(xtmp, ierr)
      ASSERT( ierr==0 )
    endif
!
!  Free work space.  All PETSc objects should be destroyed when they
!  are no longer needed.
    call VecDestroy(bx, ierr)
    ASSERT( ierr==0 )
    call VecDestroy(y, ierr)
    ASSERT( ierr==0 )
    call VecDestroy(ay, ierr)
    ASSERT( ierr==0 )
!
    call jedema()
!
#else
    integer :: x1, vlag
    vlag = x1
    ASSERT(.false.)
#endif
!
end subroutine
