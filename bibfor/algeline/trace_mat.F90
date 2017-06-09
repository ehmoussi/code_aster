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

function trace_mat(ndim,m)
!
      implicit none
!
      real(kind=8) :: trace_mat
      integer, intent(in) :: ndim
      real(kind=8), intent(in) :: m(ndim,ndim)
!
!
!     TRACE D UNE MATRICE
!
! IN NDIM : DIMENSION
! IN  M  : MATRICE
!
!
      integer :: i
!
      trace_mat = 0.d0
      do i=1,ndim
          trace_mat = trace_mat + m(i,i)
      end do
!
end function
