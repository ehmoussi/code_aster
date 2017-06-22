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

subroutine apinfi(sdappa, questi_, i_poin, vali)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sdappa
    character(len=*), intent(in) :: questi_
    integer, intent(in) :: i_poin
    integer, intent(out) :: vali
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Ask datastructure - By point - Integer
!
! --------------------------------------------------------------------------------------------------
!
! In  sdappa           : name of pairing datastructure
! In  questi           : question
!                       'APPARI_TYPE'     type of pairing
!                       'APPARI_ENTITE'   index of entity paired
!                       'APPARI_ZONE'     index of zone
!                       'APPARI_MAILLE'   element of point
! In  i_poin           : index of point (contact or non-contact)
! Out vali             : answer
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdappa_appa
    integer, pointer :: v_sdappa_appa(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    vali = 0
    sdappa_appa = sdappa(1:19)//'.APPA'
    call jeveuo(sdappa_appa, 'L', vi = v_sdappa_appa)
!
    if (questi_ .eq. 'APPARI_TYPE') then
        vali = v_sdappa_appa(4*(i_poin-1)+1)
    else if (questi_.eq.'APPARI_ENTITE') then
        vali = v_sdappa_appa(4*(i_poin-1)+2)
    else if (questi_.eq.'APPARI_ZONE') then
        vali = v_sdappa_appa(4*(i_poin-1)+3)
    else if (questi_.eq.'APPARI_MAILLE') then
        vali = v_sdappa_appa(4*(i_poin-1)+4)
    else
        ASSERT(.false.)
    endif
!
end subroutine
