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
    subroutine vipvpt(nbvari, vintm, vintp, advico, vicpvp,&
                      dimcon, p2, congem, adcp11, adcp12,&
                      ndim, pvp0, dp1, dp2, t,&
                      dt, mamolv, r, rho11, kh,&
                      signe, cp11, cp12, yate, pvp,&
                      pvpm, retcom)
        integer :: dimcon
        integer :: nbvari
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: vintp(nbvari)
        integer :: advico
        integer :: vicpvp
        real(kind=8) :: p2
        real(kind=8) :: congem(dimcon)
        integer :: adcp11
        integer :: adcp12
        integer :: ndim
        real(kind=8) :: pvp0
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: t
        real(kind=8) :: dt
        real(kind=8) :: mamolv
        real(kind=8) :: r
        real(kind=8) :: rho11
        real(kind=8) :: kh
        real(kind=8) :: signe
        real(kind=8) :: cp11
        real(kind=8) :: cp12
        integer :: yate
        real(kind=8) :: pvp
        real(kind=8) :: pvpm
        integer :: retcom
    end subroutine vipvpt
end interface
