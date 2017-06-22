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

subroutine get_patchzi_num(mesh, nmgrma, num)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/utmess.h"


! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=24), intent(in) :: nmgrma
    integer, intent(out) :: num
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Get Patch zone number in DECOUPE_LAC 
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  nmgrma           : name of izone GROUP_MA_ESCL 
! In  num              : corresponding Patch zone number in DECOUPE_LAC
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_patchzi, nb_patchzi
    aster_logical :: find
    character(len=24), pointer:: nm_patchzi(:) => null() 
!
! --------------------------------------------------------------------------------------------------
!
    call jeveuo(mesh//'.PTRNOMPAT', 'L', vk24 = nm_patchzi)
    call jelira(mesh//'.PTRNOMPAT', 'LONMAX', nb_patchzi)
    num = 0
!
    do i_patchzi=1, nb_patchzi
        if (nm_patchzi(i_patchzi).eq. nmgrma) then
            num = i_patchzi
            find=.true.                
        endif
    enddo
    if ( .not. find ) then 
        call utmess('F', 'CONTACT2_18',valk=nm_patchzi(i_patchzi))   
    endif
!
end subroutine
