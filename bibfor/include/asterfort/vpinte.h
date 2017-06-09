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
    subroutine vpinte(option, nfreq, valp, det, idet,&
                      ieme, npas, tolf, nitf, lraide,&
                      lmasse, ldynam, resufi, resufr, nfreqb,&
                      solveu)
        integer :: nfreqb
        character(len=16) :: option
        integer :: nfreq
        real(kind=8) :: valp(*)
        real(kind=8) :: det(*)
        integer :: idet(*)
        integer :: ieme(*)
        integer :: npas(*)
        real(kind=8) :: tolf
        integer :: nitf
        integer :: lraide
        integer :: lmasse
        integer :: ldynam
        integer :: resufi(nfreqb, *)
        real(kind=8) :: resufr(nfreqb, *)
        character(len=19) :: solveu
    end subroutine vpinte
end interface
