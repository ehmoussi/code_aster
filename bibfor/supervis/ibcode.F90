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

subroutine ibcode(ncode)
    implicit none
!
!   Return 1 if CODE=_F(...) is present in DEBUT or CODE='OUI' in POURSUITE else return 0.
!
#include "asterc/getexm.h"
#include "asterc/getfac.h"
#include "asterc/jdcset.h"
#include "asterfort/getvtx.h"
!
    integer, intent(out) :: ncode
!
    character(len=3) :: repons
    integer :: ier
!
    ncode = 0
    ier = getexm(' ', 'CODE')
    if (ier .eq. 1) then
!       cas de POURSUITE
        call getvtx(' ', 'CODE', scal=repons)
        if (repons .eq. 'OUI') then
            ncode = 1
        endif
    else
!       cas de DEBUT
        call getfac('CODE', ncode)
    endif
    call jdcset('icode', ncode)
end subroutine ibcode
