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
subroutine vfnulo(maxfa , maxar, ndim , nnos , nface,&
                  nbnofa, nosar, nosfa, narfa)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/elref1.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: maxfa, maxar, ndim, nnos, nface
integer, intent(out) :: nbnofa(1:nface)
integer, intent(out) :: nosar(1:maxar, 2), nosfa(1:maxfa, *), narfa(1:maxfa, *)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Utility - Get numbering of faces
!
! --------------------------------------------------------------------------------------------------
!
! In  maxfa            : maximum number of faces
! In  maxar            : maximum number of edged
! In  ndim             : dimension of space (2 or 3)
! In  nnos             : number of nodes (not middle ones)
! In  nface            : number of faces (for finite volume)
! Out nbnofa           : number of nodes by face
! Out nosar            : for each edge => list of nodes
! Out nosfa            : for each face => list of nodes
! Out narfa            : for each face => list of edges
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefe
    integer :: ifa
!
! --------------------------------------------------------------------------------------------------
!
    call elref1(elrefe)
!
    if (ndim .eq. 2) then
        ASSERT(nnos.eq.nface)
        do ifa = 1, nface
            nbnofa(ifa)  = 2
            nosfa(ifa,1) = ifa
            if ((ifa+1) .le. nnos) then
                nosfa(ifa,2) = ifa+1
            else
                nosfa(ifa,2) = ifa+1-nnos
            endif
        end do
    elseif (ndim .eq. 3) then
        if (elrefe .eq. 'H27') then
            ASSERT(nface.eq.6)
            ASSERT(nnos.eq.8)
            nbnofa(1:6) = 4
            nosar(1,1)=1
            nosar(1,2)=2
            nosar(2,1)=2
            nosar(2,2)=3
            nosar(3,1)=3
            nosar(3,2)=4
            nosar(4,1)=4
            nosar(4,2)=1
            nosar(5,1)=1
            nosar(5,2)=5
            nosar(6,1)=2
            nosar(6,2)=6
            nosar(7,1)=3
            nosar(7,2)=7
            nosar(8,1)=4
            nosar(8,2)=8
            nosar(9,1)=5
            nosar(9,2)=6
            nosar(10,1)=6
            nosar(10,2)=7
            nosar(11,1)=7
            nosar(11,2)=8
            nosar(12,1)=8
            nosar(12,2)=5
            nosfa(1,1)=1
            nosfa(1,2)=2
            nosfa(1,3)=3
            nosfa(1,4)=4
            nosfa(2,1)=1
            nosfa(2,2)=5
            nosfa(2,3)=6
            nosfa(2,4)=2
            nosfa(3,1)=2
            nosfa(3,2)=3
            nosfa(3,3)=7
            nosfa(3,4)=6
            nosfa(4,1)=7
            nosfa(4,2)=3
            nosfa(4,3)=4
            nosfa(4,4)=8
            nosfa(5,1)=1
            nosfa(5,2)=4
            nosfa(5,3)=8
            nosfa(5,4)=5
            nosfa(6,1)=5
            nosfa(6,2)=6
            nosfa(6,3)=7
            nosfa(6,4)=8
            narfa(1,1)=1
            narfa(1,2)=2
            narfa(1,3)=3
            narfa(1,4)=4
            narfa(2,1)=5
            narfa(2,2)=9
            narfa(2,3)=6
            narfa(2,4)=1
            narfa(3,1)=2
            narfa(3,2)=7
            narfa(3,3)=10
            narfa(3,4)=6
            narfa(4,1)=7
            narfa(4,2)=3
            narfa(4,3)=8
            narfa(4,4)=11
            narfa(5,1)=4
            narfa(5,2)=8
            narfa(5,3)=12
            narfa(5,4)=5
            narfa(6,1)=9
            narfa(6,2)=10
            narfa(6,3)=11
            narfa(6,4)=12
        else if (elrefe.eq.'T9') then
            ASSERT(nface.eq.4)
            ASSERT(nnos.eq.4)
            nbnofa(1:4) = 3
            nosar(1,1)=1
            nosar(1,2)=2
            nosar(2,1)=2
            nosar(2,2)=3
            nosar(3,1)=3
            nosar(3,2)=1
            nosar(4,1)=1
            nosar(4,2)=4
            nosar(5,1)=2
            nosar(5,2)=4
            nosar(6,1)=3
            nosar(6,2)=4
            nosfa(1,1)=2
            nosfa(1,2)=3
            nosfa(1,3)=4
            nosfa(2,1)=3
            nosfa(2,2)=4
            nosfa(2,3)=1
            nosfa(3,1)=4
            nosfa(3,2)=1
            nosfa(3,3)=2
            nosfa(4,1)=1
            nosfa(4,2)=2
            nosfa(4,3)=3
            narfa(1,1)=2
            narfa(1,2)=6
            narfa(1,3)=5
            narfa(2,1)=6
            narfa(2,2)=4
            narfa(2,3)=3
            narfa(3,1)=4
            narfa(3,2)=1
            narfa(3,3)=5
            narfa(4,1)=1
            narfa(4,2)=2
            narfa(4,3)=3
        else
            ASSERT(ASTER_FALSE)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
end subroutine
