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

function dmasp1(rho11, rho12 , rho21,&
                satur, dsatur,&
                phi  , cs    , pas  , l_emmag, em)
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: rho11, rho12, rho21
real(kind=8), intent(in) :: satur, dsatur
real(kind=8), intent(in) :: phi, cs, pas, em
aster_logical, intent(in) :: l_emmag
real(kind=8) :: dmasp1
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass by capillary pressure - Dry air part
!
! --------------------------------------------------------------------------------------------------
!
! In  rho11            : volumic mass of liquid
! In  rho12            : volumic mass of steam
! In  rho21            : volumic mass of dry air
! In  satur            : saturation
! In  dsatur           : derivative of saturation by capillary pressure
! In  phi              : porosity
! In  cs               : Biot modulus of solid matrix
! In  pas              : "dry" air pressure
! In  l_emmag          : .true. if use storage coefficient
! In  em               : storage coefficient
! Out dmasp1           : derivative of quantity of mass by capillary pressure - Dry air part
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: dphip1
!
! --------------------------------------------------------------------------------------------------
!
    if (l_emmag) then
        dphip1 = - satur*em
        dmasp1 = rho21 * (-dsatur*phi + (1.d0-satur)*dphip1 + phi*(1.d0-satur)/pas*rho12/rho11)
    else
        dmasp1 = rho21 * (-dsatur*phi - (1.d0-satur)*satur*cs + phi*(1.d0-satur)/pas*rho12/rho11)
    endif
!
end function
