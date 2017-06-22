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

subroutine mmptch(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/jerazo.h"
#include "asterfort/jelira.h"
#include "asterfort/jeexin.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue method - Fill pairing datastructure (MPI management)
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: sdappa
    character(len=24) :: sdappa_tgno, sdappa_tgel    
    character(len=24) :: sdappa_mpib, sdappa_mpic
    integer :: iret, length
    character(len=16), pointer :: valk(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_tgel = sdappa(1:19)//'.TGEL'
    sdappa_tgno = sdappa(1:19)//'.TGNO'
    length=cfdisi(ds_contact%sdcont_defi,'NNOCO' )
    call jerazo(sdappa_tgno,6*length,1)
    length=0
    call jelira(sdappa_tgel, 'LONT', length)
    call jerazo(sdappa_tgel, length ,1)
    sdappa_mpib = sdappa(1:19)//'.MPIB'
    sdappa_mpic = sdappa(1:19)//'.MPIC'
    call jeexin(sdappa_mpib,iret)
    if (iret .eq. 0) then
        call wkvect(sdappa_mpib,'V V K16',1,vk16=valk)
        valk(1)='MPI_INCOMPLET'
        call wkvect(sdappa_mpic,'V V K16',1,vk16=valk)
        valk(1)='MPI_INCOMPLET'
    else 
        call jeveuo(sdappa_mpib, 'E',vk16=valk)
        valk(1)='MPI_INCOMPLET'
        call jeveuo(sdappa_mpic, 'E',vk16=valk)
        valk(1)='MPI_INCOMPLET'
    endif
end subroutine
