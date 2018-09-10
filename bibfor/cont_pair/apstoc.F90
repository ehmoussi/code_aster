! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine apstoc(ds_contact, nb_pair, list_pair)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/wkvect.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jedetr.h"
#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
!
    type(NL_DS_Contact), intent(inout) :: ds_contact
    integer, intent(in):: nb_pair
    integer, pointer :: list_pair(:)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Save pairing information in sdappa data structure
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_contact       : datastructure for contact management
! In  nb_pair          : number of pairs in contact zone
! IO  list_pair        : list of pairs in contact zone
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_pair
    character(len=19) :: sdappa
    integer, pointer :: v_sdappa_apli(:) => null()
    character(len=24) :: sdappa_apli
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    if (nb_pair.ne.0) then
        sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
        sdappa_apli = sdappa(1:19)//'.APLI'
        call jedetr(sdappa_apli)
        call wkvect(sdappa_apli,'V V I', 3*nb_pair, vi = v_sdappa_apli)
        do i_pair = 1, 3*nb_pair
            v_sdappa_apli(i_pair) = list_pair(i_pair)        
        end do
        AS_DEALLOCATE(vi=list_pair)
        ds_contact%nb_cont_pair = nb_pair
    end if
    call jedema()
end subroutine
