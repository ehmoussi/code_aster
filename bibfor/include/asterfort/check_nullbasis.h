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

!
#include "asterf_types.h"
#include "asterf_petsc.h"

interface
   function check_nullbasis( vec_c, mat_z, tol )
# ifdef _HAVE_PETSC
       use aster_petsc_module
       Vec, intent(in) :: vec_c
       Mat, intent(in) :: mat_z
       PetscScalar, optional, intent(in)  :: tol
# else
       integer, intent(in) :: vec_c
       integer, intent(in) :: mat_z
       real(kind=8), optional, intent(in) :: tol
# endif
       aster_logical       :: check_nullbasis
   end function check_nullbasis
end interface
