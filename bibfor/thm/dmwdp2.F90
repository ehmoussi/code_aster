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
function dmwdp2(rho11 , satur  , phi, cs, cliq,&
                dp11p2, l_emmag, em)
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: rho11, phi, satur
real(kind=8), intent(in) :: cs, cliq, dp11p2, em
aster_logical, intent(in) :: l_emmag
real(kind=8) :: dmwdp2
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass by gaz pressure - Liquid part
!
! --------------------------------------------------------------------------------------------------
!
! In  rho11            : volumic mass of liquid
! In  phi              : porosity
! In  satur            : saturation
! In  cs               : Biot modulus of solid matrix
! In  cliq             : value of 1/K for liquid
! In  dp11p2           : derivative of liquid pressure by gaz pressure
! In  l_emmag          : .true. if use storage coefficient
! In  em               : storage coefficient
! Out dmwdp2           : derivative of quantity of mass by gaz pressure - Liquid part
!
! --------------------------------------------------------------------------------------------------
!
    if (l_emmag) then
        dmwdp2 = rho11*(phi*em+phi*cliq*dp11p2)
    else
        dmwdp2 = rho11*satur*(phi*cliq*dp11p2+cs)
    endif
!
end function
