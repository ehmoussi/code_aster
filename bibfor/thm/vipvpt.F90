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
subroutine vipvpt(ndim  , nbvari, dimcon,&
                  adcp11, adcp12,&
                  advico, vicpvp,&
                  congem,&
                  cp11  , cp12  , kh    ,&
                  mamolv, rgaz  , rho11 , signe ,&    
                  temp  , p2    ,&
                  dtemp , dp1   , dp2   ,&
                  pvp0  , pvp1  ,&
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
integer, intent(in) :: ndim, nbvari, dimcon
integer, intent(in) :: adcp11, adcp12
integer, intent(in) :: advico, vicpvp
real(kind=8), intent(in) :: congem(dimcon)
real(kind=8), intent(in) :: mamolv, rgaz, rho11, kh
real(kind=8), intent(in) :: signe, cp11, cp12
real(kind=8), intent(in) :: temp, p2
real(kind=8), intent(in) :: dtemp, dp1, dp2
real(kind=8), intent(in) :: vintm(nbvari)
real(kind=8), intent(in) :: pvp0
real(kind=8), intent(out) :: pvp1
real(kind=8), intent(out) :: vintp(nbvari)
integer, intent(out)  :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute intermediary steam pressure (with dissolved air)
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  dimcon           : dimension of generalized stresses vector
! In  adcp11           : adress of first component and first phase in generalized stresses vector
! In  adcp12           : adress of first component and second phase in generalized stresses vector
! In  advico           : index of first internal state variable for coupling law
! In  vicpvp           : index of internal state variable for pressure of steam
! In  congem           : generalized stresses - At begin of current step
! In  cp11             : specific heat capacity of liquid
! In  cp12             : specific heat capacity of steam
! In  mamolv           : molar mass of steam
! In  rgaz             : perfect gaz constant
! In  rho11            : volumic mass for liquid
! In  kh               : Henry coefficient
! In  signe            : sign for saturation
! In  temp             : temperature
! In  p2               : gaz pressure
! In  dtemp            : increment of temperature
! In  dp1              : increment of capillary pressure
! In  dp2              : increment of gaz pressure
! In  pvp0             : initial pressure for steam
! Out pvp1             : intermediary pressure for steam
! IO  vintp            : internal state variables at end of time step
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: varpv
    real(kind=8), parameter :: epxmax = 5.d0
!
! --------------------------------------------------------------------------------------------------
!
    retcom = 0
    varpv  = mamolv/rgaz/temp*(dp2-signe*dp1)/rho11-mamolv/rho11/kh*dp2
    if (ds_thm%ds_elem%l_dof_ther) then
        varpv = varpv+(congem(adcp12+ndim+1)-congem(adcp11+ndim+1))*&
                      (1.d0/(temp-dtemp)-1.d0/temp)*mamolv/rgaz
        varpv = varpv+(cp12-cp11)*(log(temp/(temp-dtemp))-(dtemp/temp))*mamolv/rgaz
    endif
    if (varpv .gt. epxmax) then
        retcom = 1
        goto 30
    endif
    vintp(advico+vicpvp) = - pvp0 + (vintm(advico+vicpvp)+pvp0)*exp(varpv)
    pvp1 = vintp(advico+vicpvp) + pvp0
    if ((p2-pvp1) .lt. 0.d0) then
        retcom = 1
        goto 30
    endif
    if ((pvp1) .lt. r8prem()) then
        retcom = 1
        goto 30
    endif
!
30  continue
!
end subroutine
