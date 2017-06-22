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
    subroutine wp2biy(lm, lc, lk, s2, dsr,&
                      isi, yh, yb, zh, zb,&
                      lbloq, u1, u2, u3, u4,&
                      n)
        integer :: lm
        integer :: lc
        integer :: lk
        real(kind=8) :: s2
        real(kind=8) :: dsr
        real(kind=8) :: isi
        real(kind=8) :: yh(*)
        real(kind=8) :: yb(*)
        real(kind=8) :: zh(*)
        real(kind=8) :: zb(*)
        integer :: lbloq(*)
        real(kind=8) :: u1(*)
        real(kind=8) :: u2(*)
        real(kind=8) :: u3(*)
        real(kind=8) :: u4(*)
        integer :: n
    end subroutine wp2biy
end interface
