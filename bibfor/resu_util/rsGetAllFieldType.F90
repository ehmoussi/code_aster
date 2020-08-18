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
subroutine rsGetAllFieldType(resultNameZ, nbField, listField, listStoreRefe)
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/rs_get_liststore.h"
!
character(len=*), intent(in) :: resultNameZ
integer, intent(out) :: nbField
character(len=16), pointer :: listField(:)
integer, pointer :: listStoreRefe(:)
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get list of type of fields in a results datastructure (at least for ONE storing index)
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! Out nbField          : number of _active_ field type in results datastructure
! Ptr listField        : pointer to type of active field in results datastructure
! Ptr listStoreRefe    : pointer to a storing index which is valid for active field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: resultName
    character(len=16) :: fieldName
    integer :: nbFieldMaxi, nbStore, iStore, iField, fieldNume
    integer, pointer :: numeStore(:) => null()
    character(len=24), pointer :: tach(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resultName = resultNameZ
!
! - Number of possible fields in results
!
    call jelira(resultName//'.DESC', 'NOMMAX', nbFieldMaxi)
    ASSERT(nbFieldMaxi .gt. 0)
!
! - Allocate
!
    AS_ALLOCATE(vk16 = listField, size = nbFieldMaxi)
    AS_ALLOCATE(vi = listStoreRefe, size = nbFieldMaxi)
    listStoreRefe = -1
!
! - Get list of storing index in results datastructure
!
    call rs_get_liststore(resultName, nbStore)
    if (nbStore .eq. 0) then
        goto 999
    endif
    AS_ALLOCATE(vi = numeStore, size = nbStore)
    call rs_get_liststore(resultName, nbStore, numeStore)
!
! - Looking for fields
!
    nbField = 0
    do iField = 1, nbFieldMaxi
        call jenuno(jexnum(resultName//'.DESC', iField), fieldName)
        call jenonu(jexnom(resultName//'.DESC', fieldName), fieldNume)
        call jeveuo(jexnum(resultName//'.TACH', fieldNume), 'L', vk24 = tach)
        do iStore = 1, nbStore
            if (tach(iStore)(1:1) .ne. ' ') then
                nbField = nbField + 1
                listField(nbField)     = fieldName
                listStoreRefe(nbField) = numeStore(iStore)
                goto 10
            endif
        end do
10      continue
    end do
!
999 continue
!
    AS_DEALLOCATE(vi = numeStore)
!
end subroutine
