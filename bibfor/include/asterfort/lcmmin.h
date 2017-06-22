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
    subroutine lcmmin(typess, essai, mod, nmat, materf,&
                      nr, nvi, yd, deps, dy,&
                      comp, nbcomm, cpmono, pgl, nfs,&
                      nsg, toutms, timed, timef, vind,&
                      sigd, epstr)
        integer :: nsg
        integer :: nfs
        integer :: nr
        integer :: nmat
        integer :: typess
        real(kind=8) :: essai
        character(len=8) :: mod
        real(kind=8) :: materf(nmat, 2)
        integer :: nvi
        real(kind=8) :: yd(nr)
        real(kind=8) :: deps(6)
        real(kind=8) :: dy(nr)
        character(len=16) :: comp(*)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: timed
        real(kind=8) :: timef
        real(kind=8) :: vind(*)
        real(kind=8) :: sigd(6)
        real(kind=8) :: epstr(6)
    end subroutine lcmmin
end interface
