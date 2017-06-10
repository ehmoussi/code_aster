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
    subroutine viporo(nbvari, vintm, vintp, advico, vicphi,&
                      phi0, deps, depsv, alphfi, dt,&
                      dp1, dp2, signe, sat, cs,&
                      tbiot, phi, phim, retcom, cbiot,&
                      unsks, alpha0, aniso)
        integer :: nbvari
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: vintp(nbvari)
        integer :: advico
        integer :: vicphi
        real(kind=8) :: phi0
        real(kind=8) :: deps(6)
        real(kind=8) :: depsv
        real(kind=8) :: alphfi
        real(kind=8) :: dt
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: signe
        real(kind=8) :: sat
        real(kind=8) :: cs
        real(kind=8) :: tbiot(6)
        real(kind=8) :: phi
        real(kind=8) :: phim
        integer :: retcom
        real(kind=8) :: cbiot
        real(kind=8) :: unsks
        real(kind=8) :: alpha0
        integer :: aniso
    end subroutine viporo
end interface 
