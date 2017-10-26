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
#include "asterf_types.h"
!
interface 
    subroutine thmCpl004(option, angl_naut,&
                         j_mater  ,&
                         ndim  , nbvari   ,&
                         dimdef, dimcon   ,&
                         adcome, adcote   , adcp11, adcp12, adcp21,&
                         addeme, addete   , addep1, addep2,&
                         temp  , p1       , p2    ,&
                         dtemp , dp1      , dp2   ,&
                         deps  , epsv     , depsv ,&
                         tbiot ,&
                         phi   , rho11    , satur ,&
                         pvp   , h11      , h12   ,&
                         congem, congep   ,&
                         vintm , vintp    , dsde  ,&
                         retcom)
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: angl_naut(3)
        integer, intent(in) :: j_mater, ndim, nbvari
        integer, intent(in) :: dimdef, dimcon
        integer, intent(in) :: adcome, adcote, adcp11, adcp12, adcp21
        integer, intent(in) :: addeme, addete, addep1, addep2
        real(kind=8), intent(in) :: temp, p1, p2
        real(kind=8), intent(in) :: dtemp, dp1, dp2
        real(kind=8), intent(in) :: epsv, depsv, deps(6), tbiot(6)
        real(kind=8), intent(out) :: phi, rho11, satur
        real(kind=8), intent(out) :: pvp, h11, h12
        real(kind=8), intent(in) :: congem(dimcon)
        real(kind=8), intent(inout) :: congep(dimcon)
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
        integer, intent(out)  :: retcom
    end subroutine thmCpl004
end interface 
