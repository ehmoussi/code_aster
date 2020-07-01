! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
interface
    subroutine tufull(option, nFourier, nbrddl, deplm, deplp,&
                      b, ktild, effint, pass, vtemp)
        integer :: nbrddl
        character(len=16) :: option
        character(len=16) :: nomte
        real(kind=8) :: deplm(nbrddl)
        real(kind=8) :: deplp(nbrddl)
        real(kind=8) :: b(4, nbrddl)
        real(kind=8) :: ktild(nbrddl, nbrddl)
        real(kind=8) :: effint(nbrddl)
        real(kind=8) :: pass(nbrddl, nbrddl)
        real(kind=8) :: vtemp(nbrddl)
        integer :: nFourier
    end subroutine tufull
end interface
