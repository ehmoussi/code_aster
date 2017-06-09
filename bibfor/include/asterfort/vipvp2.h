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
    subroutine vipvp2(nbvari, vintm, vintp, advico, vicpvp,&
                      pvp0, pvp1, p2, dp2, t,&
                      dt, kh, mamolv, r, rho11m,&
                      yate, pvp, pvpm, retcom)
        integer :: nbvari
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: vintp(nbvari)
        integer :: advico
        integer :: vicpvp
        real(kind=8) :: pvp0
        real(kind=8) :: pvp1
        real(kind=8) :: p2
        real(kind=8) :: dp2
        real(kind=8) :: t
        real(kind=8) :: dt
        real(kind=8) :: kh
        real(kind=8) :: mamolv
        real(kind=8) :: r
        real(kind=8) :: rho11m
        integer :: yate
        real(kind=8) :: pvp
        real(kind=8) :: pvpm
        integer :: retcom
    end subroutine vipvp2
end interface
