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
    subroutine projkm(nmabet, nbmabe, nbnobe, mailla, caelem, dmax_cable, &
                  nnoeca, x3dca, noebe, numail, nbcnx,&
                  cxma, xyzma, normal, itria, xbar,&
                  iproj, excent)
        character(len=24) :: nmabet
        integer :: nbmabe
        integer :: nbnobe
        character(len=8) :: mailla
        character(len=8) :: caelem
        real(kind=8) :: dmax_cable
        character(len=8) :: nnoeca
        real(kind=8) :: x3dca(*)
        integer :: noebe
        integer :: numail
        integer :: nbcnx
        integer :: cxma(*)
        real(kind=8) :: xyzma(3, *)
        real(kind=8) :: normal(*)
        integer :: itria
        real(kind=8) :: xbar(*)
        integer :: iproj
        real(kind=8) :: excent
    end subroutine projkm
end interface
