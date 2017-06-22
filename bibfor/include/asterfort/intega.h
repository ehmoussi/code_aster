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
    subroutine intega(npgf, jac, poidsf, vectx, vecty,&
                      vectz, mat11, mat22, mat33, mat12,&
                      mat13, mat23, nx, ny, nz,&
                      inte)
        integer :: npgf
        real(kind=8) :: jac(9)
        real(kind=8) :: poidsf(9)
        real(kind=8) :: vectx(9)
        real(kind=8) :: vecty(9)
        real(kind=8) :: vectz(9)
        real(kind=8) :: mat11(9)
        real(kind=8) :: mat22(9)
        real(kind=8) :: mat33(9)
        real(kind=8) :: mat12(9)
        real(kind=8) :: mat13(9)
        real(kind=8) :: mat23(9)
        real(kind=8) :: nx(9)
        real(kind=8) :: ny(9)
        real(kind=8) :: nz(9)
        real(kind=8) :: inte
    end subroutine intega
end interface
