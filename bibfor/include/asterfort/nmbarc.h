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
    subroutine nmbarc(ndim, imate, carcri, sat, biot,&
                      deps, sbism, vim,&
                      option, sbisp, vip, dsidep, p1,&
                      p2, dp1, dp2, dsidp1, sipm,&
                      sipp, retcom)
        integer :: ndim
        integer :: imate
        real(kind=8) :: carcri(*)
        real(kind=8) :: sat
        real(kind=8) :: biot
        real(kind=8) :: deps(6)
        real(kind=8) :: sbism(6)
        real(kind=8) :: vim(5)
        character(len=16) :: option
        real(kind=8) :: sbisp(6)
        real(kind=8) :: vip(5)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: dsidp1(6)
        real(kind=8) :: sipm
        real(kind=8) :: sipp
        integer :: retcom
    end subroutine nmbarc
end interface
