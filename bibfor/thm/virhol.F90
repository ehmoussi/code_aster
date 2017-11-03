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
subroutine virhol(nbvari, vintm , vintp ,&
                  advihy, vihrho,&
                  dtemp , dp1   , dp2   , dpad,& 
                  cliq  , alpliq, signe ,&
                  rho110, rho11 , rho11m,&
                  retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/THM_type.h"
!
integer, intent(in) :: nbvari
real(kind=8), intent(in) :: vintm(nbvari)
real(kind=8), intent(inout) :: vintp(nbvari)
integer, intent(in) :: advihy, vihrho
real(kind=8), intent(in) :: dtemp, dp1, dp2, dpad
real(kind=8), intent(in) :: cliq, signe, alpliq
real(kind=8), intent(in) :: rho110
real(kind=8), intent(out) :: rho11, rho11m
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute volumic mass for liquid
!
! --------------------------------------------------------------------------------------------------
!
! In  nbvari           : total number of internal state variables
! In  vintm            : internal state variables at beginning of time step
! IO  vintp            : internal state variables at end of time step
! In  advihy           : index of internal state variable for hydraulic law 
! In  vihrho           : index of internal state variable for volumic mass of liquid
! In  dtemp            : increment of temperature
! In  dp1              : increment of capillary pressure
! In  dp2              : increment of gaz pressure
! In  dpad             : increment of dissolved air pressure
! In  cliq             : value of 1/K for liquid
! In  alpliq           : value of themic dilatation for liquid
! In  signe            : sign for saturation
! In  rho110           : initial volumic mass for liquid
! Out rho11m           : volumic mass for liquid at beginning of current time step
! Out rho11            : volumic mass for liquid at end of current time step
! Out retcom           : error code 
!                         0 - everything is OK
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: varbio
    real(kind=8), parameter :: epxmax = 5.d0
!
! --------------------------------------------------------------------------------------------------
!
    retcom = 1
!
! - Volumic mass for liquid at beginning of current time step
!
    rho11m = vintm(advihy+vihrho) + rho110
!
! - Volumic mass for liquid at end of current time step
!
    varbio = (dp2-signe*dp1-dpad)*cliq - 3.d0*alpliq*dtemp
    if (varbio .le. epxmax) then
        retcom = 0
        vintp(advihy+vihrho) = - rho110 + rho11m*exp(varbio)
        rho11 = vintp(advihy+vihrho) + rho110
    endif
!
end subroutine
