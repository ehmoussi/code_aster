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
    subroutine angcou(coor, zk1, izk, icoude, zk2,&
                      rayon, theta, angl1, angl2, angl3,&
                      pgl1, pgl2, pgl3, omega, dn1n2,&
                      epsi, crit, zk3)
        real(kind=8) :: coor(9)
        real(kind=8) :: zk1(3)
        integer :: izk
        integer :: icoude
        real(kind=8) :: zk2(3)
        real(kind=8) :: rayon
        real(kind=8) :: theta
        real(kind=8) :: angl1(3)
        real(kind=8) :: angl2(3)
        real(kind=8) :: angl3(3)
        real(kind=8) :: pgl1(3, 3)
        real(kind=8) :: pgl2(3, 3)
        real(kind=8) :: pgl3(3, 3)
        real(kind=8) :: omega
        real(kind=8) :: dn1n2
        real(kind=8) :: epsi
        character(len=8) :: crit
        real(kind=8) :: zk3(3)
    end subroutine angcou
end interface
