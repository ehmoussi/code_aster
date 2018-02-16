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
subroutine lcnorm(l_norm_smooth, norm_line, norm_g,&
                  norm)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/provec.h"
!
aster_logical, intent(in) :: l_norm_smooth
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
! In  l_norm_smooth    : indicator for normals smoothing
! In  norm_line        : normal vector on linearized element
! In  norm_g           : normal vector at integration point
! Out norm             : normal vector
!
! --------------------------------------------------------------------------------------------------
!  
    integer :: jv_norm
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

    if (l_norm_smooth) then   
        call jevech('PSNO', 'L', jv_norm)
        norm(1) = zr(jv_norm-1+1)
        norm(2) = zr(jv_norm-1+2)
        norm(3) = zr(jv_norm-1+3)
    else
!        norm(1) = signe * norm_line(1)
!        norm(2) = signe * norm_line(2)
!        norm(3) = signe * norm_line(3)
        norm(1) = norm_g(1)
        norm(2) = norm_g(2)
        norm(3) = norm_g(3)
    endif
!
end subroutine
