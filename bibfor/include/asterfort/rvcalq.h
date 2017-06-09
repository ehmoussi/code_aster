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
    subroutine rvcalq(iocc, sdeval, vec1, vec2, repere,&
                      nomcp, nbcpnc, nbcpcd, option, quant,&
                      sdlieu, codir, valdir, sdcalq, courbe)
        integer :: iocc
        character(len=24) :: sdeval
        real(kind=8) :: vec1(*)
        real(kind=8) :: vec2(*)
        character(len=8) :: repere
        character(len=8) :: nomcp(*)
        integer :: nbcpnc
        integer :: nbcpcd
        character(len=16) :: option
        character(len=24) :: quant
        character(len=24) :: sdlieu
        integer :: codir
        real(kind=8) :: valdir(*)
        character(len=19) :: sdcalq
        character(len=8) :: courbe
    end subroutine rvcalq
end interface
