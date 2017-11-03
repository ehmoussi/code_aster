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
    subroutine thmFlhVF010(option, j_mater, ifa,&
                              t     , p1    , p2     , pvp, pad ,&
                              rho11 , h11   , h12    ,&
                              satur , dsatur, & 
                              valfac, valcen)
        character(len=16), intent(in) :: option
        integer, intent(in) :: j_mater
        integer, intent(in) :: ifa
        real(kind=8), intent(in) :: t, p1, p2, pvp, pad
        real(kind=8), intent(in) :: rho11, h11, h12
        real(kind=8), intent(in) :: satur, dsatur
        real(kind=8), intent(inout) :: valcen(14, 6)
        real(kind=8), intent(inout) :: valfac(6, 14, 6)
    end subroutine thmFlhVF010
end interface 
