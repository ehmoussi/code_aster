! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine lcnorm(norm_line, norm_g, norm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/provec.h"
!
real(kind=8), intent(in) :: norm_line(3), norm_g(3)
real(kind=8), intent(out) :: norm(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute normal vector
!
! --------------------------------------------------------------------------------------------------
!
! In  norm_line        : normal vector on linearized element
! In  norm_g           : normal vector at integration point
! Out norm             : normal vector
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: tmp, signe
!
! --------------------------------------------------------------------------------------------------
!
    tmp     = 0.d0
    signe   = 0.d0
    norm(:) = 0.d0
    tmp = norm_line(1)*norm_g(1)+&
          norm_line(2)*norm_g(2)+&
          norm_line(3)*norm_g(3)
    
    if (tmp .gt. 0.d0) then
        signe =  1.d0
    else
        signe = -1.d0
    end if 

!        norm(1) = signe * norm_line(1)
!        norm(2) = signe * norm_line(2)
!        norm(3) = signe * norm_line(3)
    norm(1) = norm_g(1)
    norm(2) = norm_g(2)
    norm(3) = norm_g(3)
!
end subroutine
