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
!
use THM_type
use THM_module
!
implicit none
!
#include "asterc/r8prem.h"
!
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
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute steam pressure (no dissolved air)
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  dimcon           : dimension of generalized stresses vector
! In  adcp11           : adress of first component and first phase in generalized stresses vector
! In  adcp12           : adress of first component in vector of gen. stress for second phase
! In  advico           : index of internal state variable for coupling law 
! In  vicpvp           : index of internal state variable for pressure of steam
! In  congem           : generalized stresses - At begin of current step
! In  rho11            : volumic mass for liquid at end of current time step
! In  cp11             : specific heat capacity of liquid
! In  cp12             : specific heat capacity of steam
! In  mamolv           : molar mass of steam
! In  rgaz             : perfect gaz constant
! In  signe            : sign for saturation
! In  temp             : temperature at end of current time step
! In  p2               : gaz pressure at end of current time step
! In  dtemp            : increment of temperature
! In  dp1              : increment of capillary pressure
! In  dp2              : increment of gaz pressure
! In  pvp0             : initial pressure for steam
! Out pvpm             : pressure for steam at beginning of current time step
! Out pvp              : pressure for steam at end of current time step
! In  vintm            : internal state variables at beginning of time step
! IO  vintp            : internal state variables at end of time step
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: varbio
    real(kind=8), parameter ::  epxmax = 5.d0
!
! --------------------------------------------------------------------------------------------------
!
    retcom = 0
    varbio = mamolv/rgaz/temp*(dp2-signe*dp1)/rho11
    if (ds_thm%ds_elem%l_dof_ther) then
        varbio = varbio+(congem(adcp12+ndim+1) -&
                 congem(adcp11+ndim+1))*(1.0d0/(temp-dtemp)-1.0d0/temp)*mamolv/rgaz
        varbio = varbio+(cp12-cp11)*(log(temp/(temp-dtemp))-(dtemp/temp))*mamolv/rgaz
    endif
    if (varbio .gt. epxmax) then
        retcom = 1
        goto 30
    endif
    vintp(advico+vicpvp) = - pvp0 + (vintm(advico+vicpvp)+pvp0)*exp(varbio)
    pvp  = vintp(advico+vicpvp) + pvp0
    pvpm = vintm(advico+vicpvp) + pvp0
    if ((p2-pvp) .lt. 0.d0) then
        retcom = 1
        goto 30
    endif
    if ((pvp) .lt. r8prem()) then
        retcom = 1
        goto 30
    endif
!
30  continue
!
end subroutine
