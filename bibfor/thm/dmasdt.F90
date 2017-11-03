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
function dmasdt(rho12, rho21, alp21, h11, h12, &
                satur, phi  ,&
                pas  , temp )
!
implicit none
!
real(kind=8), intent(in) :: rho12, rho21
real(kind=8), intent(in) :: satur, h11, h12
real(kind=8), intent(in) :: phi, alp21
real(kind=8), intent(in) :: temp, pas
real(kind=8) :: dmasdt
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass by temperature - Dry air part
!
! --------------------------------------------------------------------------------------------------
!
! In  rho12            : volumic mass of steam
! In  rho21            : volumic mass of dry air
! In  alp21            : thermic dilatation of dry air
! In  satur            : saturation
! In  phi              : porosity
! In  pas              : "dry" air pressure
! In  h11              : enthalpy of capillary pressure and first phase
! In  h12              : enthalpy of capillary pressure and second phase
! In  temp             : temperature
! Out dmasdt           : derivative of quantity of mass by temperature - Dry air part
!
! --------------------------------------------------------------------------------------------------
!
    dmasdt = -rho21*(rho12*phi*(1.d0-satur)*(h12-h11)/pas/temp+3.d0*alp21)
!
end function
