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
subroutine thmGetElemRefe(l_vf, elrefe, elref2)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elref1.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: l_vf
character(len=8), intent(out) :: elrefe
character(len=8), intent(out) :: elref2
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get reference elements
!
! --------------------------------------------------------------------------------------------------
!
! In  l_vf             : flag for finite volume
! Out elrefe           : reference element for non-middle nodes (linear)
! Out elref2           : reference element for middle nodes (quadratic)
!
! --------------------------------------------------------------------------------------------------
!
    call elref1(elrefe)
    if (l_vf) then
        if (elrefe .eq. 'TR7') then
            elref2 = 'TR3'
        else if (elrefe.eq.'QU9') then
            elref2 = 'QU4'
        else if (elrefe.eq.'H27') then
            elref2 = 'HE8'
        else if (elrefe.eq.'SE3') then
            elref2 = 'SE2'
        else
            ASSERT(ASTER_FALSE)
        endif
    else
        if (elrefe .eq. 'TR6') then
            elref2 = 'TR3'
        else if (elrefe.eq.'QU8') then
            elref2 = 'QU4'
        else if (elrefe.eq.'QU9') then
            elref2 = 'QU4'
        else if (elrefe.eq.'H20') then
            elref2 = 'HE8'
        else if (elrefe.eq.'P15') then
            elref2 = 'PE6'
        else if (elrefe.eq.'P13') then
            elref2 = 'PY5'
        else if (elrefe.eq.'T10') then
            elref2 = 'TE4'
        else if (elrefe.eq.'SE3') then
            elref2 = 'SE2'
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
end subroutine
