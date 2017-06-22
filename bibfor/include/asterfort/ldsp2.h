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
!
interface
    subroutine ldsp2( pc, x1, y, ierr )
#ifdef _HAVE_PETSC
       PC, intent(in)              ::  pc
       Vec, intent(in)             ::  x1
       Vec, intent(inout)          ::  y
       PetscErrorCode, intent(out) ::  ierr
#else
       integer  :: pc
       integer  :: x1
       integer  :: y
       integer(kind=4) :: ierr
#endif
    end subroutine ldsp2
end interface
