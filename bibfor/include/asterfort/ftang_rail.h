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
    subroutine ftang_rail(fn, xlocal, vitloc, cfrotd, cfrots,&
                     ktang, ctang, iadher, oldvt, oldft,&
                     oldxlo, cost, sint, ftange, flocal,&
                     vt)
        real(kind=8) :: fn
        real(kind=8) :: xlocal(3)
        real(kind=8) :: vitloc(3)
        real(kind=8) :: cfrotd
        real(kind=8) :: cfrots
        real(kind=8) :: ktang
        real(kind=8) :: ctang
        integer :: iadher
        real(kind=8) :: oldvt(2)
        real(kind=8) :: oldft(2)
        real(kind=8) :: oldxlo(3)
        real(kind=8) :: cost
        real(kind=8) :: sint
        real(kind=8) :: ftange(2)
        real(kind=8) :: flocal(3)
        real(kind=8) :: vt(2)
    end subroutine ftang_rail
end interface
