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
subroutine dspdp1(signe, tbiot, satur, dsdp1)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: signe, tbiot(6), satur
real(kind=8), intent(out) :: dsdp1(6)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Derivative of pressure part of stress by capillary pressure
!
! --------------------------------------------------------------------------------------------------
!
! In  signe            : sign for saturation
! In  tbiot            : tensor of Biot
! In  satur            : value of saturation
! Out dsdp1            : derivative of pressure part of stress by capillary pressure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
!
! --------------------------------------------------------------------------------------------------
!
    do i = 1, 6
        if (ds_thm%ds_behaviour%l_stress_bishop) then
            dsdp1(i) = signe*tbiot(i)*satur
        else
            dsdp1(i) = 0.d0
        endif
    end do
!
end subroutine
