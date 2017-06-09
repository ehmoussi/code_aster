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

recursive function det_mat(ndim,m) result(det) 
!
      implicit none
#include "asterfort/assert.h"
!
      real(kind=8) :: det
      integer, intent(in) :: ndim
      real(kind=8), intent(in) :: m(ndim,ndim)
!
!
!     DETERMINANT MATRICE TRES PETITE TAILLE (COUT FACTORIELLE N!!)
!
! IN NDIM : DIMENSION
! IN  M  : MATRICE
!
!
    real(kind=8) :: sub_m(ndim-1,ndim-1), signe, temp_det
    integer :: i,j
!
    if(ndim.gt.10) then
        write(6,*)'det_mat.F90 pour matrices taille 10 maxi'
        ASSERT(.false.)
    endif
!
    if(ndim.eq.1) then
        det = m(1,1)
    else if(ndim.eq.2) then
        det = m(1,1)*m(2,2) - m(1,2)*m(2,1)
    else if(ndim.eq.3) then
        det =  m(1,1)*(m(2,2)*m(3,3)-m(2,3)*m(3,2)) &
              -m(1,2)*(m(2,1)*m(3,3)-m(3,1)*m(2,3)) &
              +m(1,3)*(m(2,1)*m(3,2)-m(3,1)*m(2,2))
    else
        temp_det = 0.d0
        signe = 1.d0
        do i=1,ndim
            if(i.gt.1) then
                j = i-1
                sub_m(:,1:j) = m(2:,1:j)
            endif
            if(i.lt.ndim) then
                j = i+1
                sub_m(:,i:) = m(2:,j:)
            endif
            temp_det = signe*det_mat(ndim-1,sub_m)
            signe = -1.d0*signe
        end do
        det = temp_det
    endif
!
end function det_mat
