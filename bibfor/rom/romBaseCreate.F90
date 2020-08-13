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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romBaseCreate(base, nbMode_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rscrsd.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Empi), intent(in) :: base
integer, intent(in), optional :: nbMode_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create result datastructure for base
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
! In  nbMode           : number of modes to create in datatructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbMode, ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM12_3')
    endif
    nbMode = 0
    if (present(nbMode_)) then
        nbMode = nbMode_
    endif
    if (nbMode .eq. 0) then
        nbMode = 10
    endif
    call rscrsd('G', base%base, 'MODE_EMPI', nbMode)
!
end subroutine
