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

subroutine apdist(elem_type, elem_coor, elem_nbnode, ksi1, ksi2,&
                  poin_coor, dist     , vect_pm)
!
implicit none
!
#include "asterfort/elrfvf.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: elem_type
    real(kind=8), intent(in) :: elem_coor(27)
    integer, intent(in) :: elem_nbnode
    real(kind=8), intent(in) :: ksi1
    real(kind=8), intent(in) :: ksi2
    real(kind=8), intent(in) :: poin_coor(3)
    real(kind=8), intent(out) :: dist
    real(kind=8), intent(out) :: vect_pm(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Compute distance from point to its orthogonal projection
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_type        : type of element
! In  elem_coor        : coordinates of nodes of the element
! In  elem_nbnode      : number of nodes of element
! In  ksi1             : first parametric coordinate of the projection of the point
! In  ksi2             : second parametric coordinate of the projection of the point
! In  poin_coor        : coordinates of (contact) point
! Out dist             : distance between point and projection of the point
! Out vect_pm          : vector between point and projection of the point
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: poin_proj_coor(3)
    integer :: i_dime, i_node, ibid
    real(kind=8), parameter :: zero = 0.d0
    real(kind=8) :: ksi(2), ff(9)
!
! --------------------------------------------------------------------------------------------------
!
    vect_pm(1:3)        = zero
    poin_proj_coor(1:3) = zero
    ksi(1)              = ksi1
    ksi(2)              = ksi2
    dist                = 0.d0
!
! - Shape function
!
    call elrfvf(elem_type, ksi, elem_nbnode, ff, ibid)
!
! - Coordinates of projection
!
    do i_dime = 1, 3
        do i_node = 1, elem_nbnode
            poin_proj_coor(i_dime) = ff(i_node)*elem_coor(3*(i_node-1)+i_dime) + &
                                     poin_proj_coor(i_dime)
        end do
    end do
!
! - Vector Point-Projection
!
    do i_dime = 1, 3
        vect_pm(i_dime) = poin_proj_coor(i_dime) - poin_coor(i_dime)
    end do
!
! - Distance
!
    dist = sqrt(vect_pm(1)**2+vect_pm(2)**2+vect_pm(3)**2)
!
end subroutine
