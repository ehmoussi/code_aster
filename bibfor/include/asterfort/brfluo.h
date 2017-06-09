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
    subroutine brfluo(sut, sut6, xmt, sige6, eps0,&
                      tau0, dt, evp06, evp16, devpt6,&
                      evpmax, bgpgmx, eragmx)
        real(kind=8) :: sut
        real(kind=8) :: sut6(6)
        real(kind=8) :: xmt
        real(kind=8) :: sige6(6)
        real(kind=8) :: eps0
        real(kind=8) :: tau0
        real(kind=8) :: dt
        real(kind=8) :: evp06(6)
        real(kind=8) :: evp16(6)
        real(kind=8) :: devpt6(6)
        real(kind=8) :: evpmax
        real(kind=8) :: bgpgmx
        real(kind=8) :: eragmx
    end subroutine brfluo
end interface
