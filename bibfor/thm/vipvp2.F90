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
subroutine vipvp2(nbvari,&
                  advico, vicpvp,&
                  mamolv, rgaz  , rho11 , kh,&
                  pvp1  ,&
                  temp  , p2    ,&
                  dtemp , dp2   ,&
                  pvp0  , pvpm  , pvp   ,&
                  vintm , vintp ,&
                  retcom)
!
implicit none
!
#include "asterc/r8prem.h"
!
integer, intent(in) :: nbvari
integer, intent(in) :: advico, vicpvp
real(kind=8), intent(in) :: mamolv, rgaz, rho11, kh
real(kind=8), intent(in) :: pvp1
real(kind=8), intent(in) :: temp, p2
real(kind=8), intent(in) :: dtemp, dp2
real(kind=8), intent(in) :: pvp0
real(kind=8), intent(out) :: pvpm, pvp
real(kind=8), intent(in) :: vintm(nbvari)
real(kind=8), intent(out) :: vintp(nbvari)
integer, intent(out)  :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute steam pressure (with dissolved air)
!
! --------------------------------------------------------------------------------------------------
!
! In  nbvari           : total number of internal state variables
! In  advico           : index of first internal state variable for coupling law
! In  vicpvp           : index of internal state variable for pressure of steam
! In  mamolv           : molar mass of steam
! In  rgaz             : perfect gaz constant
! In  rho11            : volumic mass for liquid
! In  kh               : Henry coefficient
! In  pvp1             : intermediary pressure for steam
! In  temp             : temperature
! In  p2               : gaz pressure
! In  dtemp            : increment of temperature
! In  dp2              : increment of gaz pressure
! In  pvp0             : initial pressure for steam
! Out pvpm             : pressure for steam at beginning of current time step
! Out pvp              : pressure for steam at end of current time step
! In  vintm            : internal state variables at beginning of time step
! IO  vintp            : internal state variables at end of time step
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: varbio
!
! --------------------------------------------------------------------------------------------------
!
    retcom = 0
    varbio = (rho11*kh/pvp1)-mamolv*(1+rgaz*log(temp/(temp-dtemp)))
    if (abs(varbio) .lt. r8prem()) then
        retcom = 1
        goto 30
    endif
    pvpm = vintm(advico+vicpvp) + pvp0
    pvp  = (rho11*kh-mamolv*(pvpm+(p2-dp2)*rgaz*log(temp/(temp-dtemp))))/varbio
    if ((p2-pvp) .lt. 0.d0) then
        retcom = 1
        goto 30
    endif
    vintp(advico+vicpvp) = pvp - pvp0
!
30  continue
!
end subroutine
