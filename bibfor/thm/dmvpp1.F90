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
function dmvpp1(rho11, rho12, phids, cs ,&
                dpvpl, satur, phi  , pvp)
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: rho11, rho12, phids, cs, dpvpl, satur, phi, pvp
real(kind=8) :: dmvpp1
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass from steam pressure by liquid pressure - With steam only
!
! --------------------------------------------------------------------------------------------------
!
! In  rho11            : volumic mass of liquid
! In  rho12            : volumic mass of steam
! In  phids            : product porosity by derivative of saturation (/pc)
! In  dpvpl            : derivative of steam pressure by liquid pressure
! In  cs               : Biot modulus of solid matrix
! In  dpvpt            : derivative of steam pressure by temperature
! In  satur            : saturation
! In  phi              : porosity
! In  pvp              : steam pressure
! Out dmvpp1           : derivative of quantity of mass from steam pressure by liquid pressure
!
! --------------------------------------------------------------------------------------------------
!
    dmvpp1 = rho12*((-phids-(1.d0-satur)*(1.d0-satur)*cs)*dpvpl+&
                      phids+(1.d0-satur)*satur*cs+phi*(1.d0-satur)*rho12/rho11/pvp)
!
end function
