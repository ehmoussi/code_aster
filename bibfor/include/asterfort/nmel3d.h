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
    subroutine nmel3d(fami, poum, nno, npg, ipoids,&
                      ivf, idfde, geom, typmod, option,&
                      imate, compor, lgpg, crit, depl,&
                      angmas, dfdi, pff, def, sig,&
                      vi, matuu, vectu, codret)
        integer :: lgpg
        integer :: npg
        integer :: nno
        character(len=*) :: fami
        character(len=*) :: poum
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        real(kind=8) :: geom(3, nno)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: imate
        character(len=16) :: compor(*)
        real(kind=8) :: crit(3)
        real(kind=8) :: depl(1:3, 1:nno)
        real(kind=8) :: angmas(3)
        real(kind=8) :: dfdi(nno, 3)
        real(kind=8) :: pff(6, nno, nno)
        real(kind=8) :: def(6, nno, 3)
        real(kind=8) :: sig(6, npg)
        real(kind=8) :: vi(lgpg, npg)
        real(kind=8) :: matuu(*)
        real(kind=8) :: vectu(3, nno)
        integer :: codret
    end subroutine nmel3d
end interface
