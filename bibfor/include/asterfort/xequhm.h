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
    subroutine xequhm(imate, option, ta, ta1, ndim,&
                      compor, kpi, npg, dimenr,&
                      enrmec, dimdef, dimcon, nbvari, defgem,&
                      congem, vintm, defgep, congep, vintp,&
                      mecani, press1, press2, tempe,&
                      rinstp, dt, r, drds,&
                      dsde, retcom, idecpg, angmas, enrhyd, nfh)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: dimenr
        integer :: imate
        character(len=16) :: option
        real(kind=8) :: ta
        real(kind=8) :: ta1
        integer :: ndim
        character(len=16) :: compor(*)
        integer :: kpi
        integer :: npg
        integer :: enrmec(3)
        real(kind=8) :: defgem(dimdef)
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: defgep(dimdef)
        real(kind=8) :: congep(dimcon)
        real(kind=8) :: vintp(nbvari)
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        real(kind=8) :: rinstp
        real(kind=8) :: dt
        real(kind=8) :: r(dimenr)
        real(kind=8) :: drds(dimenr, dimcon)
        real(kind=8) :: dsde(dimcon, dimenr)
        integer :: retcom
        integer :: idecpg
        real(kind=8) :: angmas(3)
        integer :: enrhyd(3)
        integer :: nfh
    end subroutine xequhm
end interface 
