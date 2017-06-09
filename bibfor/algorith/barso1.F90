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

subroutine barso1(n1, n2, n3, coor, poin)
    implicit   none
    integer :: n1, n2, n3, poin(*)
    real(kind=8) :: coor(*)
!     BARSOUM :
!-----------------------------------------------------------------------
!
    real(kind=8) :: vx, vy, vz
!     ------------------------------------------------------------------
!
    vx = 0.25d0 * ( coor(3*(poin(n2)-1)+1) - coor(3*(poin(n1)-1)+1) )
    vy = 0.25d0 * ( coor(3*(poin(n2)-1)+2) - coor(3*(poin(n1)-1)+2) )
    vz = 0.25d0 * ( coor(3*(poin(n2)-1)+3) - coor(3*(poin(n1)-1)+3) )
!
    coor(3*(poin(n3)-1)+1) = coor(3*(poin(n1)-1)+1) + vx
    coor(3*(poin(n3)-1)+2) = coor(3*(poin(n1)-1)+2) + vy
    coor(3*(poin(n3)-1)+3) = coor(3*(poin(n1)-1)+3) + vz
!
end subroutine
