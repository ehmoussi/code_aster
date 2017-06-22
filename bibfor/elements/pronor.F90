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

subroutine pronor(nx, ny, nz, vtan, vnor)
    implicit none
    real(kind=8) :: nx, ny, nz, scal
    real(kind=8) :: vtan(3), vnor(3)
!
    scal = nx*vtan(1) + ny*vtan(2) + nz*vtan(3)
!
    vnor(1) = nx*scal
    vnor(2) = ny*scal
    vnor(3) = nz*scal
!
    vtan(1) = vtan(1) - vnor(1)
    vtan(2) = vtan(2) - vnor(2)
    vtan(3) = vtan(3) - vnor(3)
!
end subroutine
