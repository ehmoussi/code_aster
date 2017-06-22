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

subroutine op0068()
!
implicit none
!
#include "asterc/getres.h"
#include "asterfort/charac.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!

!
! --------------------------------------------------------------------------------------------------
!
! COMMAND:  AFFE_CHAR_ACOU
!
! --------------------------------------------------------------------------------------------------
!
    character(len=4) :: vale_type
    character(len=8) :: load
    character(len=16) :: k16dummy
    character(len=8), pointer :: p_load_type(:) => null() 
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
!
! - Which command ?
!
    call getres(load, k16dummy, k16dummy)
    call wkvect(load//'.TYPE', 'G V K8', 1, vk8 = p_load_type)
    p_load_type(1) = 'ACOU_RE'
    vale_type      = 'REEL'
!
! - Loads treatment
!
    call charac(load, vale_type)
!
    call jedema()
end subroutine
