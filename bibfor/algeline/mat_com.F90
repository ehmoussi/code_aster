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

function mat_com(ndim,m)
!
      implicit none
!
#include "asterfort/det_mat.h"
      integer,intent(in) :: ndim
      real(kind=8), intent(in) :: m(ndim,ndim)
      real(kind=8) :: mat_com(ndim,ndim)
!
!
!     COMATRICE D UNE MATRICE DE PETITE TAILLE
!
! IN  NDIM : DIMENSION DE LA MATRICE
! IN  M    : MATRICE NDIM*NDIM
!
      integer :: i,j, im1, ip1, jm1, jp1
      real(kind=8) :: signe, signe2, mat_red(ndim-1,ndim-1)
!
      signe = 1.d0
      signe2 = 1.d0
      do i=1,ndim
          signe = signe2
          do j=1,ndim
              im1 = i-1
              jm1 = j-1
              ip1 = i+1
              jp1 = j+1
              if(i.gt.1.and.j.gt.1) then
                  mat_red(1:im1,1:jm1) = m(1:im1,1:jm1)
              endif
              if(i.gt.1.and.j.lt.ndim) then
                  mat_red(1:im1,j:) = m(1:im1,jp1:)
              endif
              if(i.lt.ndim.and.j.gt.1) then
                  mat_red(i:,1:jm1) = m(ip1:,1:jm1)
              endif
              if(i.lt.ndim.and.j.lt.ndim) then
                  mat_red(i:,j:) = m(ip1:,jp1:)
              endif
              mat_com(i,j) = signe*det_mat(ndim-1,mat_red)
              signe = -1.d0*signe
          end do
          signe2 = -1.d0*signe2
      end do
!
end function
