! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine resuIdeasPermut(permutJvName, versio, maxnod)
!
implicit none
!
#include "asterfort/iradhs.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
!
character(len=24), intent(in) :: permutJvName
integer, intent(in) :: versio
integer, intent(out) :: maxnod
!
! --------------------------------------------------------------------------------------------------
!
! Result management
!
! Ideas - SuperTab (permutation)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, lonl
    integer, pointer :: permuta(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    maxnod = 0
    call jeexin(permutJvName, iret)
    if (iret .eq. 0) then
        call iradhs(versio)
    endif
    call jeveuo(permutJvName, 'L', vi=permuta)
    call jelira(permutJvName, 'LONMAX', lonl)
    maxnod = permuta(lonl)
!
end subroutine
