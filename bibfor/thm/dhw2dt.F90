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

function dhw2dt(dp11t, alpliq, temp, rho11, cp11)
!
implicit none
!
#include "asterfort/dhdt.h"
!
real(kind=8), intent(in) :: temp, dp11t, alpliq, rho11, cp11
real(kind=8) :: dhw2dt
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of enthalpy of liquid by temperature
!
! --------------------------------------------------------------------------------------------------
!
! In  dp11t            : partial derivative of liquid pressure by temperature
! In  alpliq           : value of thermic dilatation for liquid
! In  temp             : temperature
! In  rho11            : volumic mass of liquid
! In  cp11             : specific heat capacity of liquid
! Out dhw2dt           : derivative of enthalpy of liquid by temperature
!
! --------------------------------------------------------------------------------------------------
!
    dhw2dt = dp11t * (1.d0-3.d0*alpliq*temp)/rho11 + dhdt(cp11)
!
end function
