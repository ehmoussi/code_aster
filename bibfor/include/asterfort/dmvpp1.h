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
    function dmvpp1(rho11, rho12, phids, ums, cs,&
                    dpvpl, sat, phi, pvp)
        real(kind=8) :: rho11
        real(kind=8) :: rho12
        real(kind=8) :: phids
        real(kind=8) :: ums
        real(kind=8) :: cs
        real(kind=8) :: dpvpl
        real(kind=8) :: sat
        real(kind=8) :: phi
        real(kind=8) :: pvp
        real(kind=8) :: dmvpp1_0
    end function dmvpp1
end interface 
