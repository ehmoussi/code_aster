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
#include "asterf_types.h"
!
interface
    subroutine cal152(option, max, may, maz, model,&
                      phib24, iphi1, iphi2, imade, modmec,&
                      chamno, num, vrai, i, j,&
                      mij, cij, kij)
        character(len=9) :: option
        character(len=19) :: max
        character(len=19) :: may
        character(len=19) :: maz
        character(len=2) :: model
        character(len=24) :: phib24
        integer :: iphi1
        integer :: iphi2
        integer :: imade
        character(len=8) :: modmec
        character(len=19) :: chamno
        character(len=14) :: num
        aster_logical :: vrai
        integer :: i
        integer :: j
        real(kind=8) :: mij
        real(kind=8) :: cij
        real(kind=8) :: kij
    end subroutine cal152
end interface
