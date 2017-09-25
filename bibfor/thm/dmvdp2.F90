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
function dmvdp2(rho11  , rho12 ,&
                satur  ,&
                phi    , cs    , pvp,&
                l_emmag, em)
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: rho11, rho12
real(kind=8), intent(in) :: satur
real(kind=8), intent(in) :: phi, cs, pvp, em
aster_logical, intent(in) :: l_emmag
real(kind=8) :: dmvdp2
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of quantity of mass by gaz pressure - Steam part
!
! --------------------------------------------------------------------------------------------------
!
! In  rho11            : volumic mass of liquid
! In  rho12            : volumic mass of steam
! In  satur            : saturation
! In  phi              : porosity
! In  cs               : Biot modulus of solid matrix
! In  pvp              : steam pressure
! In  l_emmag          : .true. if use storage coefficient
! In  em               : storage coefficient
! Out dmvdp2           : derivative of quantity of mass by gaz pressure - Steam part
!
! --------------------------------------------------------------------------------------------------
!
    if (l_emmag) then
        dmvdp2 = rho12 * ((1.d0-satur)*em + phi*(1.d0-satur)/pvp*rho12/rho11)
    else
        dmvdp2 = rho12 * ((1.d0-satur)*cs + phi*(1.d0-satur)/pvp*rho12/rho11)
    endif
!
end function
