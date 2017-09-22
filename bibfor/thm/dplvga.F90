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
! aslint: disable=W1504
!
subroutine dplvga(ndim  , dimcon,&
                  rho11 , rho12 , rgaz  , kh,&
                  congem, adcp11, adcp12,&
                  temp  , pad   ,&
                  dp11p1, dp11p2,&
                  dp12p1, dp12p2,&
                  dp21p1, dp21p2,&
                  dp11t , dp12t , dp21t)
!
use THM_type
use THM_module
!
implicit none
!
integer, intent(in) :: ndim, dimcon
real(kind=8), intent(in) :: rho11, rho12, rgaz, kh
integer, intent(in) :: adcp11, adcp12
real(kind=8), intent(in) :: congem(dimcon), temp, pad
real(kind=8), intent(out) :: dp11p1, dp11p2
real(kind=8), intent(out) :: dp12p1, dp12p2
real(kind=8), intent(out) :: dp21p1, dp21p2
real(kind=8), intent(out) :: dp11t, dp12t, dp21t
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute partial derivatives for 'LIQU_AD_GAZ_VAPE'
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  dimcon           : dimension of generalized stresses vector
! In  rho11            : volumic mass of liquid
! In  rho12            : volumic mass of steam
! In  rgaz             : perfect gaz constant
! In  kh               : Henry coefficient
! In  temp             : temperature
! In  pad              : dissolved air pressure
! Out dp11p1           : partial derivative of liquid pressure by capillary pressure
! Out dp11p2           : partial derivative of liquid pressure by gaz pressure
! Out dp12p1           : partial derivative of steam pressure by capillary pressure
! Out dp12p2           : partial derivative of steam pressure by gaz pressure
! Out dp21p1           : partial derivative of dry air pressure by capillary pressure
! Out dp21p2           : partial derivative of dry air pressure by gaz pressure
! Out dp11t            : partial derivative of liquid pressure by temperature
! Out dp12t            : partial derivative of steam pressure by temperature
! Out dp21t            : partial derivative of dry air pressure by temperature
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: l
!
! --------------------------------------------------------------------------------------------------
!
    dp11p1 = 1/((rho12*rgaz*temp/rho11/kh)-1)
    dp11p2 = (rgaz*temp/kh - 1)/((rho12*rgaz*temp/rho11/kh)-1)
    dp12p1 = 1/(rgaz*temp/kh-(rho11/rho12))
    dp12p2 = (rgaz*temp/kh-1)*dp12p1
    dp21p1 = - dp12p1
    dp21p2 = 1 - dp12p2
    if (ds_thm%ds_elem%l_dof_ther) then
        l = (congem(adcp12+ndim+1)-congem(adcp11+ndim+1))
        dp11t = (-l*rgaz*rho12/kh+pad/temp)/((rho12*rgaz*temp/rho11/kh)-1)
        dp12t = (-l*rho11+pad)/temp*dp12p1
        dp21t = - dp12t
    endif
!
end subroutine
