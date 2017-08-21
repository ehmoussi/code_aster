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
subroutine sigmap(satur, signe, tbiot, dp2, dp1,&
                  sigmp)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: signe, tbiot(6), satur, dp1, dp2
real(kind=8), intent(out) :: sigmp(6)
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
! In  dp1              : increment of first pressure
! In  dp2              : increment of second pressure
! Out sigmp            : stress component for pressure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
!
! --------------------------------------------------------------------------------------------------
!
    do i = 1, 6
        if (ds_thm%ds_behaviour%l_stress_bishop) then
            sigmp(i) = tbiot(i)*satur*signe*dp1 - tbiot(i)*dp2
        else
            sigmp(i) = - tbiot(i)*dp2
        endif
    end do
!
end subroutine
