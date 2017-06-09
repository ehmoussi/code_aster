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
    subroutine iredm1(masse, noma, basemo, nbmode, nbmods,&
                      iamor, mass, rigi, amored, freq,&
                      smass, srigi, samor, cmass, crigi,&
                      camor)
        character(len=8) :: masse
        character(len=8) :: noma
        character(len=8) :: basemo
        integer :: nbmode
        integer :: nbmods
        integer :: iamor
        real(kind=8) :: mass(*)
        real(kind=8) :: rigi(*)
        real(kind=8) :: amored(*)
        real(kind=8) :: freq(*)
        real(kind=8) :: smass(*)
        real(kind=8) :: srigi(*)
        real(kind=8) :: samor(*)
        real(kind=8) :: cmass(*)
        real(kind=8) :: crigi(*)
        real(kind=8) :: camor(*)
    end subroutine iredm1
end interface
