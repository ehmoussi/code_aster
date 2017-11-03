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
subroutine capaca(rho0 , rho11, rho12, rho21 , rho22,&
                  satur, phi  ,&
                  csigm, cp11 , cp12 , cp21  , cp22 ,&
                  dalal, temp , coeps, retcom)
!
implicit none
!
#include "asterfort/utmess.h"
!
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
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute specific heat capacity
!
! --------------------------------------------------------------------------------------------------
!
! In  rho0             : volumic mass of homogeneized solid
! In  rho11            : volumic mass of liquid
! In  rho12            : volumic mass of steam
! In  rho21            : volumic mass of dry air
! In  rho22            : volumic mass of dissolved air
! In  satur            : saturation
! In  phi              : porosity
! In  csigm            : specific heat capacity of solid
! In  cp11             : specific heat capacity of liquid
! In  cp12             : specific heat capacity of steam
! In  cp21             : specific heat capacity of dry air
! In  cp22             : specific heat capacity of dissolved air
! In  temp             : temperature
! In  dalal            : product <alpha> [Elas] {alpha} - Thermic dilatation for solid
! Out coeps            : specific heat capacity
! Out retcom           : error code 
!                         0 - everything is OK
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: umprhs
!
! --------------------------------------------------------------------------------------------------
!
    retcom = 0
    coeps  = 0.d0
    umprhs = 0.d0
!
! - Volumic mass of solid
!
    umprhs = rho0-(rho11+rho22)*satur*phi-(rho12+rho21)*(1.d0-satur)*phi
    if (umprhs .le. 0.d0) then
        retcom = 1
        goto 30
    endif
!
! - Specific heat capacity
!
    coeps = umprhs*csigm + &
            phi*satur*(rho11*cp11+rho22*cp22) + &
            phi*(1.d0-satur)*(rho12*cp12+rho21*cp21)
!
! - Add thermic dilatation from mechanic
!
    coeps = coeps - temp*dalal
    if (coeps .le. 0.d0) then
        retcom = 1
    endif
!
30  continue
!
end subroutine
