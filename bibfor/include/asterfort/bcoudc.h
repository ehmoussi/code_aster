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
    subroutine bcoudc(igau, icou, isect, h, a,&
                      m, omega, xpg, nno, ncou,&
                      nsect, ff, df1, df2, rayon,&
                      theta, mmt, b)
        integer :: igau
        integer :: icou
        integer :: isect
        real(kind=8) :: h
        real(kind=8) :: a
        integer :: m
        real(kind=8) :: omega
        real(kind=8) :: xpg(4)
        integer :: nno
        integer :: ncou
        integer :: nsect
        real(kind=8) :: ff(*)
        real(kind=8) :: df1(*)
        real(kind=8) :: df2(*)
        real(kind=8) :: rayon
        real(kind=8) :: theta
        integer :: mmt
        real(kind=8) :: b(4, *)
    end subroutine bcoudc
end interface
