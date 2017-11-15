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

function check_nullbasis( vec_c, mat_z, tol ) result ( is_ok )
!
#include "asterf_petsc.h"
use aster_petsc_module

implicit none
!
! person_in_charge: natacha.bereux at edf.fr
#include "asterfort/infniv.h"
#include "asterfort/assert.h"
!
!----------------------------------------------------------------
!
!     Vérification de l'orthogonalité de la base stockée dans
!     mat_z par rapport au vecteur vec_c
!
! ---------------------------------------------------------------
#ifdef _HAVE_PETSC
! Dummy arguments
   Vec, intent(in)                    :: vec_c
   Mat, intent(in)                    :: mat_z
   PetscScalar, optional, intent(in)  :: tol
   aster_logical                      :: is_ok
! Local variables
   integer                  :: ifm, niv
   Vec                      :: vec_cz
   PetscErrorCode           :: ierr
   PetscScalar              :: tol_loc, norm
   PetscScalar, parameter   :: tolmax=1.d-10
   aster_logical            :: verbose
!
   call infniv(ifm, niv)
   verbose=(niv == 2)
!
  if (present(tol)) then
     tol_loc = tol
  else
     tol_loc = tolmax
  endif
! Allocation d'un vecteur de travail pour calculer le produit vec_c * mat_z
#if PETSC_VERSION_LT(3,8,0)
  call MatCreateVecs( mat_z, vec_cz, PETSC_NULL_OBJECT, ierr)
#else
  call MatCreateVecs( mat_z, vec_cz, PETSC_NULL_VEC, ierr)
#endif
  ASSERT(ierr == 0)
  call MatMultTranspose(mat_z, vec_c, vec_cz, ierr)
  call VecNorm(vec_cz, norm_2, norm, ierr)
!
  if (verbose) write(ifm,*),'   |C(IC,:).T|=', norm
  if (verbose) write(ifm,*),' '
!
  is_ok = (norm < tol_loc)
!
! Libération de la mémoire
  call VecDestroy(vec_cz, ierr)
!
#else
    integer, intent(in)         :: vec_c, mat_z
    real(kind=8), optional, intent(in)  :: tol
    aster_logical               :: is_ok
    integer :: idummy
    real(kind=8) :: rdummy
    idummy = vec_c + mat_z
    rdummy = tol
    is_ok = .false.
#endif
end function check_nullbasis
