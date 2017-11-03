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
function dmvpd2(rho12, alp12, dpvpt, phi, satur,&
                pvp  , phids, cs)
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: rho12, alp12, dpvpt, phi, pvp, phids, cs, satur
real(kind=8) :: dmvpd2
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass from steam pressure by gaz pressure - With steam only
!
! --------------------------------------------------------------------------------------------------
!
! In  rho12            : volumic mass of steam
! In  alp12            : thermic dilatation of steam
! In  dpvpt            : derivative of steam pressure by temperature
! In  phi              : porosity
! In  satur            : saturation
! In  pvp              : steam pressure
! In  phids            : product porosity by derivative of saturation (/pc)
! In  cs               : Biot modulus of solid matrix
! Out dmvpd2           : derivative of quantity of mass from steam pressure by gaz pressure
!
! --------------------------------------------------------------------------------------------------
!
    dmvpd2 = rho12*(-3.d0*alp12 + dpvpt*(phi*(1.d0-satur)/pvp-phids+(1.d0-satur)*(1.d0-satur)*cs))
!
end function
