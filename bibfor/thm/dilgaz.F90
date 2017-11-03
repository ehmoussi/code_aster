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
function dilgaz(satur, phi, alphfi, temp)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
!
real(kind=8), intent(in) :: satur
real(kind=8), intent(in) :: phi
real(kind=8), intent(in) :: alphfi
real(kind=8), intent(in) :: temp
real(kind=8) :: dilgaz
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute thermal expansion of gaz
!
! --------------------------------------------------------------------------------------------------
!
! In  satur            : saturation
! In  phi              : porosity
! In  alphfi           : differential thermal expansion ratio
! Out dilgaz           : thermal expansion of gaz
!
! --------------------------------------------------------------------------------------------------
!
    dilgaz = (1.d0-satur)*alphfi+phi*(1.d0-satur)/3.d0/temp
!
end function
