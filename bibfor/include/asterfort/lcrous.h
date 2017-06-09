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
    subroutine lcrous(fami, kpg, ksp, toler, itmax,&
                      imat, nmat, materd, materf, nvi,&
                      deps, sigd, vind, theta, loi,&
                      dt, sigf, vinf, irtet)
        integer :: nvi
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        real(kind=8) :: toler
        integer :: itmax
        integer :: imat
        real(kind=8) :: materd(nmat, 2)
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: deps(6)
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(nvi)
        real(kind=8) :: theta
        character(len=16) :: loi
        real(kind=8) :: dt
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(nvi)
        integer :: irtet
    end subroutine lcrous
end interface
