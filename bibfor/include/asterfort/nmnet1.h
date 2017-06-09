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
    subroutine nmnet1(zimat, nmnbn, cnbn, cplas, czef,&
                      czeg, cief, cdeps, cdtg, cier,&
                      cdepsp, dc, normm)
        integer :: zimat
        real(kind=8) :: nmnbn(6)
        real(kind=8) :: cnbn(6)
        real(kind=8) :: cplas(2, 3)
        real(kind=8) :: czef
        real(kind=8) :: czeg
        integer :: cief
        real(kind=8) :: cdeps(6)
        real(kind=8) :: cdtg(6, 6)
        integer :: cier
        real(kind=8) :: cdepsp(6)
        real(kind=8) :: dc(6, 6)
        real(kind=8) :: normm
    end subroutine nmnet1
end interface
