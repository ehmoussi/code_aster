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
subroutine vfgetr(xs  , t   , xg ,&
                  surf, norm, xgf, d)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/provec.h"
!
real(kind=8), intent(in) :: xs(3, 3), t(3, 2), xg(3)
real(kind=8), intent(out) :: surf, norm(3), xgf(3), d
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Utility - Compute geometric parameters for a triangular face
!
! --------------------------------------------------------------------------------------------------
!
! In  xs               : coordinates of nodes
! In  t                : vector of the first edge
! In  xg               : coordinates of point to orient face
! Out surf             : surface of triangle
! Out norm             : normal at triangle
! Out xgf              : coordinates of center of face
! Out d                : value (xfg-xg)*norm
!
! --------------------------------------------------------------------------------------------------
!
    integer :: idim, is
    real(kind=8) :: xnorm
!
! --------------------------------------------------------------------------------------------------
!
    do idim = 1, 3
        xgf(idim)=0.d0
        do is = 1, 3
            xgf(idim)=xgf(idim)+xs(idim,is)
        end do
        xgf(idim)=xgf(idim)/3
    end do
!
    call provec(t(1, 1), t(1, 2), norm)
    xnorm   = sqrt(norm(1)**2+norm(2)**2+norm(3)**2)
    norm(1) = norm(1)/xnorm
    norm(2) = norm(2)/xnorm
    norm(3) = norm(3)/xnorm
    surf    = xnorm/2.d0
!
    d       = (xgf(1)-xg(1))*norm(1)+&
              (xgf(2)-xg(2))*norm(2)+&
              (xgf(3)-xg(3))*norm(3)
    if (d .lt. 0.d0) then
        d       = -d
        norm(1) = -norm(1)
        norm(2) = -norm(2)
        norm(3) = -norm(3)
    endif
!
end subroutine
