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
function dmwdp1(rho11, signe, satur , dsatur , phi,&
                cs   , cliq , dp11p1, l_emmag, em )
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: rho11, signe, phi, satur, dsatur
real(kind=8), intent(in) :: cs, cliq, dp11p1, em
aster_logical, intent(in) :: l_emmag
real(kind=8) :: dmwdp1
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass of liquid by capillary pressure
!
! --------------------------------------------------------------------------------------------------
!
! In  rho11            : volumic mass of liquid
! In  signe            : sign for saturation
! In  phi              : porosity
! In  satur            : saturation
! In  dsatur           : derivative of saturation by capillary pressure
! In  cs               : Biot modulus of solid matrix
! In  cliq             : value of 1/K for liquid
! In  dp11p1           : derivative of liquid pressure by capillary pressure
! In  l_emmag          : .true. if use storage coefficient
! In  em               : storage coefficient
! Out dmwdp1           : derivative of quantity of mass of liquid by capillary pressure
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: dphip1
!
! --------------------------------------------------------------------------------------------------
!
    if (l_emmag) then
        dphip1 = - satur*signe*em
        dmwdp1 = rho11*(satur*dphip1+signe*dsatur*phi- signe*satur*phi*cliq*dp11p1)
    else
        dmwdp1 = rho11*signe*(dsatur*phi - satur*phi*cliq*dp11p1 - satur*satur*cs)
    endif
!
end function
