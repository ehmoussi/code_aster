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

subroutine apinfr(sdappa, questi_, i_poin, valr)
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
    real(kind=8), intent(out) :: valr
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
!                       'APPARI_PROJ_KSI1'  first para. coor. of projection of point
!                       'APPARI_PROJ_KSI2'  second para. coor. of projection of point
!                       'APPARI_DIST'       distance point-projection
! In  i_poin           : index of point (contact or non-contact)
! Out valr             : answer
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdappa_dist
    real(kind=8), pointer :: v_sdappa_dist(:) => null()
    character(len=24) :: sdappa_proj
    real(kind=8), pointer :: v_sdappa_proj(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    valr = 0.d0
    sdappa_proj = sdappa(1:19)//'.PROJ'
    sdappa_dist = sdappa(1:19)//'.DIST'
    call jeveuo(sdappa_proj, 'L', vr = v_sdappa_proj)
    call jeveuo(sdappa_dist, 'L', vr = v_sdappa_dist)
!
    if (questi_ .eq. 'APPARI_PROJ_KSI1') then
        valr = v_sdappa_proj(2*(i_poin-1)+1)
    else if (questi_.eq.'APPARI_PROJ_KSI2') then
        valr = v_sdappa_proj(2*(i_poin-1)+2)
    else if (questi_.eq.'APPARI_DIST') then
        valr = v_sdappa_dist(4*(i_poin-1)+1)
    else
        ASSERT(.false.)
    endif
!
end subroutine
