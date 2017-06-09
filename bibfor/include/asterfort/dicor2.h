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
    subroutine dicor2(k0, p1, p2, dur, dryr,&
                      dxu, dryu, feq, nu, mu,&
                      uu, tt, si1, dnsdu, dmsdt,&
                      dnsdt, varip1, varip2, si2)
        real(kind=8) :: k0(78)
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: dur
        real(kind=8) :: dryr
        real(kind=8) :: dxu
        real(kind=8) :: dryu
        real(kind=8) :: feq
        real(kind=8) :: nu
        real(kind=8) :: mu
        real(kind=8) :: uu
        real(kind=8) :: tt
        real(kind=8) :: si1(12)
        real(kind=8) :: dnsdu
        real(kind=8) :: dmsdt
        real(kind=8) :: dnsdt
        real(kind=8) :: varip1
        real(kind=8) :: varip2
        real(kind=8) :: si2(12)
    end subroutine dicor2
end interface
