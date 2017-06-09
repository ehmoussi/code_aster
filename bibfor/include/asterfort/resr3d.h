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
    subroutine resr3d(rota, coor, ff, rho, nno,&
                      npg, frx, fry, frz)
        real(kind=8) :: rota(*)
        real(kind=8) :: coor(1)
        real(kind=8) :: ff(1)
        real(kind=8) :: rho
        integer :: nno
        integer :: npg
        real(kind=8) :: frx(27)
        real(kind=8) :: fry(27)
        real(kind=8) :: frz(27)
    end subroutine resr3d
end interface
