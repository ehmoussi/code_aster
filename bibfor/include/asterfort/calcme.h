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
! aslint: disable=W1504
!
interface 
    subroutine calcme(option, compor, thmc, meca, imate,&
                      typmod, carcri, instam, instap,&
                      ndim, dimdef, dimcon, nvimec, yate,&
                      addeme, adcome, addete, defgem, congem,&
                      congep, vintm, vintp, addep1, addep2,&
                      dsde, deps, p1, p2,&
                      dt, retcom, dp1, dp2,&
                      sat, tbiot, angl_naut)
        integer :: nvimec
        integer :: dimcon
        integer :: dimdef
        character(len=16) :: option
        character(len=16) :: compor(*)
        character(len=16) :: thmc
        character(len=16) :: meca
        integer :: imate
        character(len=8) :: typmod(2)
        real(kind=8) :: carcri(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: ndim
        integer :: yate
        integer :: addeme
        integer :: adcome
        integer :: addete
        real(kind=8) :: defgem(dimdef)
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: congep(dimcon)
        real(kind=8) :: vintm(nvimec)
        real(kind=8) :: vintp(nvimec)
        integer :: addep1
        integer :: addep2
        real(kind=8) :: dsde(dimcon, dimdef)
        real(kind=8) :: deps(6)
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: dt
        integer :: retcom
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: sat
        real(kind=8) :: tbiot(6)
        real(kind=8), intent(in) :: angl_naut(3)
    end subroutine calcme
end interface 
