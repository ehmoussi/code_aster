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

function nbsigm()
    implicit none
#include "asterfort/assert.h"
#include "asterfort/teattr.h"
#include "asterfort/utmess.h"
    integer :: nbsigm
!     BUT : NOMBRE DE CONTRAINTES ASSOCIE AU TYPE_ELEM COURANT
!-----------------------------------------------------------------------
!
    character(len=8) :: nbsig
    integer :: iret
!
    call teattr('C', 'NBSIGM', nbsig, iret)
    if (iret .ne. 0) then
        call utmess('F', 'ELEMENTS_90')
    endif
!
!
    if (nbsig .eq. '4') then
        nbsigm=4
    else if (nbsig.eq.'6') then
        nbsigm=6
    else
        ASSERT(.false.)
    endif
!
end function
