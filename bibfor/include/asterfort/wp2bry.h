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
    subroutine wp2bry(ldrf, lmasse, lamor, lraide, sr,&
                      si2, yh, yb, zh, zb,&
                      u1, u2, u3, u4, n,&
                      solveu)
        integer :: ldrf
        integer :: lmasse
        integer :: lamor
        integer :: lraide
        real(kind=8) :: sr
        real(kind=8) :: si2
        real(kind=8) :: yh(*)
        real(kind=8) :: yb(*)
        real(kind=8) :: zh(*)
        real(kind=8) :: zb(*)
        real(kind=8) :: u1(*)
        real(kind=8) :: u2(*)
        real(kind=8) :: u3(*)
        real(kind=8) :: u4(*)
        integer :: n
        character(len=19) :: solveu
    end subroutine wp2bry
end interface
