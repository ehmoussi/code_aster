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

function norm_mat(ndim,m)
!
      implicit none
!
      integer, intent(in) :: ndim
      real(kind=8), intent(in) :: m(ndim,ndim)
      real(kind=8) :: norm_mat
!
!
!     NORME D UNE MATRICE
!
! IN  NDIM : DIMENSION DE LA MATRICE
! IN  M    : MATRICE NDIM*NDIM
!
      integer :: i,j
!
      norm_mat = 0.d0
      do i=1,ndim
          do j=1,ndim
              norm_mat = norm_mat + m(i,j)*m(i,j)
          end do
      end do
      norm_mat = sqrt(norm_mat)
!
end function
