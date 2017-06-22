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
    subroutine intenc(nbna, jac, vectx, vecty, mat11,&
                      mat22, mat12, nx, ny, inte)
        integer :: nbna
        real(kind=8) :: jac(3)
        real(kind=8) :: vectx(3)
        real(kind=8) :: vecty(3)
        real(kind=8) :: mat11(3)
        real(kind=8) :: mat22(3)
        real(kind=8) :: mat12(3)
        real(kind=8) :: nx(3)
        real(kind=8) :: ny(3)
        real(kind=8) :: inte
    end subroutine intenc
end interface
