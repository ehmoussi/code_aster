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
    subroutine clffch(alias, type, nno, xi, yi,&
                      zi, xin, yin, zin, tn,&
                      ajx, ajy, ajz, bjxx, bjyy,&
                      bjzz, bjxy, bjxz, bjyz, ider)
        character(len=6) :: alias
        character(len=6) :: type
        integer :: nno
        real(kind=8) :: xi
        real(kind=8) :: yi
        real(kind=8) :: zi
        real(kind=8) :: xin(1)
        real(kind=8) :: yin(1)
        real(kind=8) :: zin(1)
        real(kind=8) :: tn(1)
        real(kind=8) :: ajx(1)
        real(kind=8) :: ajy(1)
        real(kind=8) :: ajz(1)
        real(kind=8) :: bjxx(1)
        real(kind=8) :: bjyy(1)
        real(kind=8) :: bjzz(1)
        real(kind=8) :: bjxy(1)
        real(kind=8) :: bjxz(1)
        real(kind=8) :: bjyz(1)
        integer :: ider
    end subroutine clffch
end interface
