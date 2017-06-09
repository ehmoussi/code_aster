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

subroutine apvect(sdappa, questi_, i_poin, valr)
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
    real(kind=8), intent(out) :: valr(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Ask datastructure - By point - Vector
!
! --------------------------------------------------------------------------------------------------
!
! In  sdappa           : name of pairing datastructure
! In  questi           : question
!                       'APPARI_TAU1'           first tangent at projection of point
!                       'APPARI_TAU2'           second tangent at projection of point
!                       'APPARI_NOEUD_TAU1'     first tangent at node
!                       'APPARI_NOEUD_TAU2'     second tangent at node
!                       'APPARI_VECTPM'         vector between point and its projection
! In  i_poin           : index of point (contact or non-contact)
! Out valr             : answer
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdappa_dist
    real(kind=8), pointer :: v_sdappa_dist(:) => null()
    character(len=24) :: sdappa_tau1
    real(kind=8), pointer :: v_sdappa_tau1(:) => null()
    character(len=24) :: sdappa_tau2
    real(kind=8), pointer :: v_sdappa_tau2(:) => null()
    character(len=24) :: sdappa_tgno
    real(kind=8), pointer :: v_sdappa_tgno(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sdappa_tau1 = sdappa(1:19)//'.TAU1'
    sdappa_tau2 = sdappa(1:19)//'.TAU2'
    sdappa_dist = sdappa(1:19)//'.DIST'
    sdappa_tgno = sdappa(1:19)//'.TGNO'
    call jeveuo(sdappa_tau1, 'L', vr = v_sdappa_tau1)
    call jeveuo(sdappa_tau2, 'L', vr = v_sdappa_tau2)
    call jeveuo(sdappa_dist, 'L', vr = v_sdappa_dist)
    call jeveuo(sdappa_tgno, 'L', vr = v_sdappa_tgno)
    valr(1:3) = 0.d0
!
    if (questi_ .eq. 'APPARI_TAU1') then
        valr(1) = v_sdappa_tau1(3*(i_poin-1)+1)
        valr(2) = v_sdappa_tau1(3*(i_poin-1)+2)
        valr(3) = v_sdappa_tau1(3*(i_poin-1)+3)
    else if (questi_.eq.'APPARI_TAU2') then
        valr(1) = v_sdappa_tau2(3*(i_poin-1)+1)
        valr(2) = v_sdappa_tau2(3*(i_poin-1)+2)
        valr(3) = v_sdappa_tau2(3*(i_poin-1)+3)
    else if (questi_.eq.'APPARI_VECTPM') then
        valr(1) = v_sdappa_dist(4*(i_poin-1)+2)
        valr(2) = v_sdappa_dist(4*(i_poin-1)+3)
        valr(3) = v_sdappa_dist(4*(i_poin-1)+4)
    else if (questi_.eq.'APPARI_NOEUD_TAU1') then
        valr(1) = v_sdappa_tgno(6*(i_poin-1)+1)
        valr(2) = v_sdappa_tgno(6*(i_poin-1)+2)
        valr(3) = v_sdappa_tgno(6*(i_poin-1)+3)
    else if (questi_.eq.'APPARI_NOEUD_TAU2') then
        valr(1) = v_sdappa_tgno(6*(i_poin-1)+4)
        valr(2) = v_sdappa_tgno(6*(i_poin-1)+5)
        valr(3) = v_sdappa_tgno(6*(i_poin-1)+6)
    else
        ASSERT(.false.)
    endif
!
end subroutine
