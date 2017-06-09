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

subroutine apelem_getcenter(elem_code, ksi1_cent, ksi2_cent)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    character(len=8), intent(in) :: elem_code
    real(kind=8), intent(out) :: ksi1_cent
    real(kind=8), intent(out) :: ksi2_cent
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get center of element in parametric space
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_code        : code of current element
! Out ksi1_cent        : first parametric coordinate for center of element
! Out ksi2_cent        : second parametric coordinate for center of element
!
! --------------------------------------------------------------------------------------------------
!
    ksi1_cent = 0.d0
    ksi2_cent = 0.d0
!    
    if (elem_code .eq. 'SE2'.or.&
        elem_code .eq. 'SE3') then
        ksi1_cent   = 0.d0 
    elseif (elem_code .eq. 'TR3'.or.&
            elem_code .eq. 'TR6') then
        ksi1_cent   = 1.d0/3.d0
        ksi2_cent   = 1.d0/3.d0
    elseif (elem_code .eq. 'QU4' .or.&
            elem_code .eq. 'QU8' .or.&
            elem_code .eq. 'QU9') then
        ksi1_cent   = 0.d0
        ksi2_cent   = 0.d0
    else
        ASSERT(.false.) 
    end if
!
end subroutine
