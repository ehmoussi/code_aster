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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine op0028()
!
implicit none
!
#include "asterc/getres.h"
#include "asterfort/dfllad.h"
#include "asterfort/dflldb.h"
#include "asterfort/dfllec.h"
#include "asterfort/dfllty.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: sdlist
    character(len=16) :: k16bid
    character(len=16) :: list_method
    real(kind=8) :: dtmin
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infmaj()
    call infniv(ifm, niv)
!
! - Get result datastructure
!
    call getres(sdlist, k16bid, k16bid)
!
! - Read parameters for keyword DEFI_LIST 
!
    call dfllty(sdlist, list_method, dtmin)
!
! - Read parameters for keyword ECHEC
!
    call dfllec(sdlist, dtmin)
!
! - Read parameters for keyword ADAPTATION
!
    if (list_method .eq. 'AUTO') then
        call dfllad(sdlist)
    endif
!
! - Print debug
!
    if (niv .ge. 2) then
        call dflldb(sdlist)
    endif

end subroutine
