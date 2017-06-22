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
interface 
    subroutine b3d_bwpw(biot0, vw0, xsat, poro0, epsvt,&
                        epsvpw, epsvpg, vg, pw1, bw1,&
                        xnsat, mfr1, pw0, dpw, vw1)
        real(kind=8) :: biot0
        real(kind=8) :: vw0
        real(kind=8) :: xsat
        real(kind=8) :: poro0
        real(kind=8) :: epsvt
        real(kind=8) :: epsvpw
        real(kind=8) :: epsvpg
        real(kind=8) :: vg
        real(kind=8) :: pw1
        real(kind=8) :: bw1
        real(kind=8) :: xnsat
        integer :: mfr1
        real(kind=8) :: pw0
        real(kind=8) :: dpw
        real(kind=8) :: vw1
    end subroutine b3d_bwpw
end interface 
