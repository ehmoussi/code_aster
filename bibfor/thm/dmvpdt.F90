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
function dmvpdt(rho12, alp12, h11, h12,&
                satur, phi  ,&
                pvp  , temp)
!
implicit none
!
real(kind=8), intent(in) :: rho12, alp12, h11, h12
real(kind=8), intent(in) :: satur, phi
real(kind=8), intent(in) :: pvp, temp
real(kind=8) :: dmvpdt
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass by temperature - Steam part
!
! --------------------------------------------------------------------------------------------------
!
! In  rho12            : volumic mass of steam
! In  alp12            : thermic dilatation of steam
! In  satur            : saturation
! In  phi              : porosity
! In  h11              : enthalpy of capillary pressure and first phase
! In  h12              : enthalpy of capillary pressure and second phase
! In  pvp              : steam pressure
! In  temp             : temperature
! Out dmvpdt           : derivative of quantity of mass by temperature - Steam part
!
! --------------------------------------------------------------------------------------------------
!
    dmvpdt = rho12*(rho12*phi*(1.d0-satur)*(h12-h11)/pvp/temp - 3.d0*alp12)
!
end function
