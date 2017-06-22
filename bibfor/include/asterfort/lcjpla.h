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
    subroutine lcjpla(fami, kpg, ksp, loi, mod,&
                      nr, imat, nmat, mater, nvi,&
                      deps, sigf, vin, dsde, sigd,&
                      vind, vp, vecp, theta, dt,&
                      devg, devgii, codret)
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: loi
        character(len=8) :: mod
        integer :: nr
        integer :: imat
        real(kind=8) :: mater(nmat, 2)
        integer :: nvi
        real(kind=8) :: deps(6)
        real(kind=8) :: sigf(6)
        real(kind=8) :: vin(*)
        real(kind=8) :: dsde(6, 6)
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        real(kind=8) :: vp(3)
        real(kind=8) :: vecp(3, 3)
        real(kind=8) :: theta
        real(kind=8) :: dt
        real(kind=8) :: devg(*)
        real(kind=8) :: devgii
        integer :: codret
    end subroutine lcjpla
end interface
