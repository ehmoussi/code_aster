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

subroutine apcopt(sdappa, i_poin, poin_coor)
!
implicit none
!
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sdappa
    integer, intent(in) :: i_poin
    real(kind=8), intent(out) :: poin_coor(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Get coordinate of point
!
! --------------------------------------------------------------------------------------------------
!
! In  sdappa           : name of pairing datastructure
! In  i_poin           : current index of point
! Out poin_coor        : coordinates of point
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdappa_poin
    real(kind=8), pointer :: v_sdappa_poin(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sdappa_poin = sdappa(1:19)//'.POIN'
    call jeveuo(sdappa_poin, 'L', vr = v_sdappa_poin)
!
    poin_coor(1) = v_sdappa_poin(3*(i_poin-1)+1)
    poin_coor(2) = v_sdappa_poin(3*(i_poin-1)+2)
    poin_coor(3) = v_sdappa_poin(3*(i_poin-1)+3)
!
end subroutine
