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
    subroutine extract_nonzero_col(a, acnz, icolnz_c)
#ifdef _HAVE_PETSC
      use aster_petsc_module
      Mat, intent(in)  :: a
      Mat, intent(out) :: acnz
      PetscInt, dimension(:), pointer :: icolnz_c
#else
      integer, intent(in)  :: a
      integer, intent(out)  :: acnz
      integer, dimension(:), pointer :: icolnz_c
#endif
!
    end subroutine
end interface
