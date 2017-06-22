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
    subroutine zevolu(cine, z, zm, dinst, tp,&
                      k, n, tdeq, tfeq, coeffc,&
                      m, ar, br, g, dg)
        integer :: cine
        real(kind=8) :: z
        real(kind=8) :: zm
        real(kind=8) :: dinst
        real(kind=8) :: tp
        real(kind=8) :: k
        real(kind=8) :: n
        real(kind=8) :: tdeq
        real(kind=8) :: tfeq
        real(kind=8) :: coeffc
        real(kind=8) :: m
        real(kind=8) :: ar
        real(kind=8) :: br
        real(kind=8) :: g
        real(kind=8) :: dg
    end subroutine zevolu
end interface
