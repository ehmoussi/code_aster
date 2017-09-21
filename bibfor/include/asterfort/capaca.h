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
    subroutine capaca(rho0 , rho11, rho12, rho21 , rho22,&
                      satur, phi  ,&
                      csigm, cp11 , cp12 , cp21  , cp22 ,&
                      dalal, temp , coeps, retcom)
        real(kind=8), intent(in) :: rho0
        real(kind=8), intent(in) :: rho11
        real(kind=8), intent(in) :: rho12
        real(kind=8), intent(in) :: rho21
        real(kind=8), intent(in) :: rho22
        real(kind=8), intent(in) :: satur
        real(kind=8), intent(in) :: phi
        real(kind=8), intent(in) :: csigm
        real(kind=8), intent(in) :: cp11
        real(kind=8), intent(in) :: cp12
        real(kind=8), intent(in) :: cp21
        real(kind=8), intent(in) :: cp22
        real(kind=8), intent(in) :: temp
        real(kind=8), intent(in) :: dalal
        real(kind=8), intent(out) :: coeps
        integer, intent(out) :: retcom
    end subroutine capaca
end interface 
