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
    subroutine rc36sp(nbm, ima, ipt, c, k,&
                      cara, mati, pi, mi, matj,&
                      pj, mj, mse, nbthp, nbthq,&
                      ioc1, ioc2, spij, typeke, spmeca,&
                      spther)
        integer :: nbm
        integer :: ima(*)
        integer :: ipt
        real(kind=8) :: c(*)
        real(kind=8) :: k(*)
        real(kind=8) :: cara(*)
        real(kind=8) :: mati(*)
        real(kind=8) :: pi
        real(kind=8) :: mi(*)
        real(kind=8) :: matj(*)
        real(kind=8) :: pj
        real(kind=8) :: mj(*)
        real(kind=8) :: mse(*)
        integer :: nbthp
        integer :: nbthq
        integer :: ioc1
        integer :: ioc2
        real(kind=8) :: spij
        real(kind=8) :: typeke
        real(kind=8) :: spmeca
        real(kind=8) :: spther
    end subroutine rc36sp
end interface
