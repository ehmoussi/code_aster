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
    subroutine sroptg(val, dum, dt, nbmat, mater,&
                      invar, s, sel, ucrpm,&
                      ucrvm, ucriv, seuilv, vinm, nvi, de,&
                      depsv, dside, retcom)
        integer :: nbmat
        integer :: val
        integer :: dum
        integer :: nvi
        real(kind=8) :: dt
        real(kind=8) :: mater(nbmat, 2)
        real(kind=8) :: invar
        real(kind=8) :: s(6)
        real(kind=8) :: sel(6)
        real(kind=8) :: ucrpm
        real(kind=8) :: ucrvm
        real(kind=8) :: ucriv
        real(kind=8) :: seuilv
        real(kind=8) :: vinm(nvi)
        real(kind=8) :: de(6, 6)
        real(kind=8) :: depsv(6)
        real(kind=8) :: dside(6, 6)
        integer :: retcom
    end subroutine sroptg
end interface
