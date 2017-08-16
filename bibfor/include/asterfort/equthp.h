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
! aslint: disable=W1504
!
interface 
    subroutine equthp(imate, option, ndim, compor, typmod,&
                      kpi, npg, dimdef, dimcon, nbvari,&
                      defgem, congem, vintm, defgep, congep,&
                      vintp, mecani, press1, press2, tempe,&
                      crit, rinstm, rinstp, r, drds,&
                      dsde, retcom, angmas,&
                meca, thmc, ther, hydr,&
                advihy, advico, vihrho, vicphi, vicpvp, vicsat)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: imate
        character(len=16) :: option
        integer :: ndim
        character(len=16) :: compor(*)
        character(len=8) :: typmod(2)
        integer :: kpi
        integer :: npg
        real(kind=8) :: defgem(1:dimdef)
        real(kind=8) :: congem(1:dimcon)
        real(kind=8) :: vintm(1:nbvari)
        real(kind=8) :: defgep(1:dimdef)
        real(kind=8) :: congep(1:dimcon)
        real(kind=8) :: vintp(1:nbvari)
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        real(kind=8) :: crit(*)
        real(kind=8) :: rinstm
        real(kind=8) :: rinstp
        real(kind=8) :: r(1:dimdef+1)
        real(kind=8) :: drds(1:dimdef+1, 1:dimcon)
        real(kind=8) :: dsde(1:dimcon, 1:dimdef)
        integer :: retcom
        real(kind=8) :: angmas(3)
        character(len=16), intent(in) :: meca
        character(len=16), intent(in) :: thmc
        character(len=16), intent(in) :: ther
        character(len=16), intent(in) :: hydr
        integer, intent(in) :: advihy
        integer, intent(in) :: advico
        integer, intent(in) :: vihrho
        integer, intent(in) :: vicphi
        integer, intent(in) :: vicpvp
        integer, intent(in) :: vicsat
    end subroutine equthp
end interface 
