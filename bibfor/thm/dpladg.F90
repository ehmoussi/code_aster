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
subroutine dpladg(ndim  , dimcon,&
                  rgaz  , kh    ,&
                  congem, adcp11,&
                  temp  , pad   ,&
                  dp11p1, dp11p2,&
                  dp21p1, dp21p2,&
                  dp11t , dp21t)
!
use THM_type
use THM_module
!
implicit none
!
integer, intent(in) :: ndim, dimcon
real(kind=8), intent(in) :: rgaz, kh
integer, intent(in) :: adcp11
real(kind=8), intent(in) :: congem(dimcon), temp, pad
real(kind=8), intent(out) :: dp11p1, dp11p2
real(kind=8), intent(out) :: dp21p1, dp21p2
real(kind=8), intent(out) :: dp11t, dp21t
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute partial derivatives for 'LIQU_AD_GAZ'
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  dimcon           : dimension of generalized stresses vector
! In  rgaz             : perfect gaz constant
! In  kh               : Henry coefficient
! In  temp             : temperature
! In  pad              : dissolved air pressure
! Out dp11p1           : partial derivative of liquid pressure by capillary pressure
! Out dp11p2           : partial derivative of liquid pressure by gaz pressure
! Out dp21p1           : partial derivative of dry air pressure by capillary pressure
! Out dp21p2           : partial derivative of dry air pressure by gaz pressure
! Out dp11t            : partial derivative of liquid pressure by temperature
! Out dp21t            : partial derivative of dry air pressure by temperature
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: l
!
! --------------------------------------------------------------------------------------------------
!
    dp11p1 = -1.d0
    dp11p2 = -(rgaz*temp/kh - 1.d0)
    dp21p1 = 0.d0
    dp21p2 = 1.d0
    if (ds_thm%ds_elem%l_dof_ther) then
        l = -congem(adcp11+ndim+1)
        dp11t = -(pad/temp)
        dp21t = 0.d0
    endif
!
end subroutine
