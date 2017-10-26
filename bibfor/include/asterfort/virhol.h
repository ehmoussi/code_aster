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
    subroutine virhol(nbvari, vintm , vintp ,&
                      advihy, vihrho,&
                      dtemp , dp1   , dp2   , dpad,& 
                      cliq  , alpliq, signe ,&
                      rho110, rho11 , rho11m,&
                      retcom)
        integer, intent(in) :: nbvari
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        integer, intent(in) :: advihy, vihrho
        real(kind=8), intent(in) :: dtemp, dp1, dp2, dpad
        real(kind=8), intent(in) :: cliq, signe, alpliq
        real(kind=8), intent(in) :: rho110
        real(kind=8), intent(out) :: rho11, rho11m
        integer, intent(out) :: retcom
    end subroutine virhol
end interface
