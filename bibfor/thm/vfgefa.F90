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
subroutine vfgefa(nnos, xs  , t  , xg,&
                  surf, norm, xgf, d ,&
                  iret)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/provec.h"
#include "asterfort/vfgetr.h"
!
integer, intent(in) :: nnos
real(kind=8), intent(in) :: xg(3), xs(3, nnos), t(3, nnos)
real(kind=8), intent(out) :: surf, norm(3), xgf(3), d
integer, intent(out) :: iret
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Utility - Compute geometric parameters for a face (coplanar)
!
! --------------------------------------------------------------------------------------------------
!
! In  nnos             : number of nodes (not middle ones)
! In  xs               : coordinates of nodes
! In  t                : vector of the edges
! In  xg               : coordinates of point to orient face
! Out surf             : surface of face
! Out norm             : normal at face
! Out xgf              : coordinates of center of face
! Out d                : value (xfg-xg)*norm
! Out iret             : 1 if error
!
! --------------------------------------------------------------------------------------------------
!
    integer :: idim, is
    real(kind=8) :: xs1(3, 3), t1(3, 2)
    real(kind=8) :: surf1, norm1(3), xgf1(3), d1
    real(kind=8) :: xs2(3, 3), t2(3, 2)
    real(kind=8) :: surf2, norm2(3), xgf2(3), d2, n1vn2(3)
    real(kind=8) :: xn1n2
!
! --------------------------------------------------------------------------------------------------
!
    iret = 0
    ASSERT(nnos .ge. 3)
!
    if (nnos .eq. 3) then
        call vfgetr(xs  , t   , xg ,&
                    surf, norm, xgf, d)
    else
        do idim = 1, 3
            xgf(idim) = 0.d0
            do is = 1, nnos
                xgf(idim) = xgf(idim)+xs(idim,is)
            end do
            xgf(idim) = xgf(idim)/nnos
        end do
! ----- Cut in two triangles
        do idim = 1, 3
            xs1(idim,1) = xs(idim,1)
            xs1(idim,2) = xs(idim,2)
            xs1(idim,3) = xs(idim,3)
            t1(idim,1)  = t(idim,1)
            t1(idim,2)  = t(idim,2)
        end do
        call vfgetr(xs1  , t1   , xg  ,&
                    surf1, norm1, xgf1, d1)
        do idim = 1, 3
            xs2(idim,1) = xs(idim,3)
            xs2(idim,2) = xs(idim,4)
            xs2(idim,3) = xs(idim,1)
            t2(idim,1)  = t(idim,3)
            t2(idim,2)  = t(idim,4)
        end do
        call vfgetr(xs2  , t2   , xg  ,&
                    surf2, norm2, xgf2, d2)
! ----- Checks normals
        call provec(norm1, norm2, n1vn2)
        xn1n2 = sqrt(n1vn2(1)**2+n1vn2(2)**2+n1vn2(3)**2)
        if (xn1n2 .gt. 1.d-6) then
            iret = 1
        else
            iret = 0
            surf = surf1+surf2
            norm(1)=norm2(1)
            norm(2)=norm2(2)
            norm(3)=norm2(3)
            d =(xgf(1)-xg(1))*norm(1)+&
               (xgf(2)-xg(2))*norm(2)+&
               (xgf(3)-xg(3))*norm(3)
            ASSERT(d.gt.0.d0)
        endif
    endif
end subroutine
