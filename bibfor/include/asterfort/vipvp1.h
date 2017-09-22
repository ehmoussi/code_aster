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
    subroutine vipvp1(ndim  , nbvari,&
                      dimcon,&
                      adcp11, adcp12, advico, vicpvp,&
                      congem, &
                      cp11  , cp12  ,&
                      mamolv, rgaz  , rho11 , signe ,&
                      temp  , p2    ,&
                      dtemp , dp1   , dp2   ,&
                      pvp0  , pvpm  , pvp   ,&
                      vintm , vintp ,&
                      retcom)
        integer, intent(in) :: ndim, dimcon, nbvari
        integer, intent(in) :: adcp11, adcp12
        integer, intent(in) :: advico, vicpvp
        real(kind=8), intent(in) :: congem(dimcon)
        real(kind=8), intent(in) :: rho11, cp11, cp12, mamolv, rgaz
        real(kind=8), intent(in) :: signe
        real(kind=8), intent(in) :: temp, p2
        real(kind=8), intent(in) :: dtemp, dp1, dp2
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        real(kind=8), intent(in) :: pvp0
        real(kind=8), intent(out) :: pvp, pvpm
        integer, intent(out) :: retcom
    end subroutine vipvp1
end interface
