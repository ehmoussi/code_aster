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
function calor(mdal , temp , dtemp, deps,&
               dp1  , dp2  , signe,&
               alp11, alp12, coeps, ndim)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
!
real(kind=8), intent(in) :: mdal(6)
real(kind=8), intent(in) :: temp
real(kind=8), intent(in) :: dtemp
real(kind=8), intent(in) :: deps(6)
real(kind=8), intent(in) :: dp1
real(kind=8), intent(in) :: dp2
real(kind=8), intent(in) :: signe
real(kind=8), intent(in) :: alp11
real(kind=8), intent(in) :: alp12
real(kind=8), intent(in) :: coeps
integer, intent(in) ::  ndim
real(kind=8) :: calor
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute "reduced" heat Q'
!
! --------------------------------------------------------------------------------------------------
!
! In  mdal             : product [Elas] {alpha}
! In  temp             : temperature
! In  dtemp            : increment of temperature
! In  deps             : increment of mechanical strains vector
! In  dp1              : increment of capillary pressure
! In  dp2              : increment of gaz pressure
! In  signe            : sign for saturation
! In  alp11            : thermic dilatation of liquid
! In  alp12            : thermic dilatation of steam
! In  coeps            : specific heat capacity
! In  ndim             : dimension of space (2 or 3)
! Out calor            : "reduced" heat Q'
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: calome
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!
! --------------------------------------------------------------------------------------------------
!
    calome = 0.d0
    do i = 1, ndim
        calome = calome+mdal(i)*deps(i)*(temp-dtemp/2.d0)
    end do
    do i = ndim+1, 2*ndim
        calome = calome+mdal(i)*deps(i)*(temp-dtemp/2.d0)*rac2
    end do
    calor = calome +&
            3.d0*alp11*(temp-dtemp/2.d0)*signe*dp1 -&
            3.d0*(alp11+alp12)*(temp-dtemp/2.d0)*dp2 +&
            coeps*dtemp
!
end function
