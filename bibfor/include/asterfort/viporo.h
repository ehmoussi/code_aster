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
! aslint: disable=W1504
!
interface 
    subroutine viporo(nbvari,&
                      advico, vicphi,&
                      dtemp , dp1   , dp2   ,&
                      deps  , depsv ,&
                      signe , satur , unsks , phi0,&
                      cs0   , tbiot , cbiot ,&
                      alpha0, alphfi,&
                      vintm , vintp ,&
                      phi   , phim  , retcom)
        integer, intent(in) :: nbvari
        integer, intent(in) :: advico, vicphi
        real(kind=8), intent(in) :: dtemp, dp1, dp2
        real(kind=8), intent(in) :: deps(6), depsv
        real(kind=8), intent(in) :: signe, satur, unsks, phi0
        real(kind=8), intent(in) :: cs0, tbiot(6), cbiot
        real(kind=8), intent(in) :: alpha0, alphfi
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        real(kind=8), intent(out) :: phi, phim
        integer, intent(out) :: retcom
    end subroutine viporo
end interface 
