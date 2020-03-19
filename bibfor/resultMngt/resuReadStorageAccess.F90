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
!
subroutine resuReadStorageAccess(storeAccess, storeCreaNb,&
                                 storeIndxNb, storeIndx  ,&
                                 storeTimeNb, storeTime  ,&
                                 storeEpsi  , storeCrit)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/uttrii.h"
#include "asterfort/wkvect.h"
!
integer, intent(out) :: storeIndxNb, storeTimeNb
character(len=10), intent(out) :: storeAccess
integer, intent(out) :: storeCreaNb
character(len=19), intent(out) :: storeIndx, storeTime
real(kind=8), intent(out) :: storeEpsi
character(len=8), intent(out) :: storeCrit
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Read parameters to access storage
!
! --------------------------------------------------------------------------------------------------
!
! Out storeAccess      : how to access to the storage
! Out storeCreaNb      : number of storage slots to create
! Out storeIndxNb      : number of storage slots given by index (integer)
! Out storeIndx        : name of JEVEUX object to access storage slots given by index (integer)
! Out storeTimeNb      : number of storage slots given by time/freq (real)
! Out storeTime        : name of JEVEUX object to access storage slots given by time/freq (real)
! Out storeEpsi        : tolerance to find time/freq (real)
! Out storeCrit        : type of tolerance to find time/freq (real)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: answer
    integer :: nbOcc
    integer, pointer :: vStoreIndx(:) => null()
    real(kind=8), pointer :: vStoreTime(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    storeAccess = ' '
    storeCreaNb = 0
    storeIndxNb = 0
    storeTimeNb = 0
    storeIndx   = ' '
    storeTime   = ' '
    storeEpsi   = 0.d0
    storeCrit   = ' '
    call getvtx(' ', 'TOUT_ORDRE', scal=answer, nbret=nbOcc)
    if (nbOcc .ne. 0) then
        storeAccess = 'TOUT_ORDRE'
        storeCreaNb = 100
        goto 99
    endif
!
    call getvis(' ', 'NUME_ORDRE', nbval=0, nbret=storeIndxNb)
    if (storeIndxNb .ne. 0) then
        storeAccess = 'NUME_ORDRE'
        storeIndx   = '&&OP0150'
        storeIndxNb = -storeIndxNb
        call wkvect(storeIndx//'.VALE', 'V V I', storeIndxNb, vi = vStoreIndx)
        call getvis(' ', 'NUME_ORDRE', nbval=storeIndxNb, vect=vStoreIndx, nbret=nbOcc)
        call uttrii(vStoreIndx, storeIndxNb)
        goto 99
    endif
!
    call getvid(' ', 'LIST_ORDRE', scal=storeIndx, nbret=storeIndxNb)
    if (storeIndxNb .ne. 0) then
        storeAccess = 'LIST_ORDRE'
        call jeveuo(storeIndx//'.VALE', 'L', vi = vStoreIndx)
        call jelira(storeIndx//'.VALE', 'LONMAX', storeIndxNb)
        call uttrii(vStoreIndx, storeIndxNb)
        goto 99
    endif
!
    call getvr8(' ', 'INST', nbval=0, nbret = storeTimeNb)
    if (storeTimeNb .ne. 0) then
        storeAccess = 'INST'
        storeTime   = '&&OP0150'
        storeTimeNb = - storeTimeNb
        call wkvect(storeTime//'.VALE', 'V V R', storeTimeNb, vr = vStoreTime)
        call getvr8(' ', 'INST', nbval=storeTimeNb, vect=vStoreTime, nbret=nbOcc)
        goto 99
    endif
!
    call getvid(' ', 'LIST_INST', scal=storeTime, nbret=storeTimeNb)
    if (storeTimeNb .ne. 0) then
        storeAccess = 'LIST_INST'
        call jelira(storeTime//'.VALE', 'LONMAX', storeTimeNb)
        goto 99
    endif
!
    call getvr8(' ', 'FREQ', nbval=0, nbret=storeTimeNb)
    if (storeTimeNb .ne. 0) then
        storeAccess = 'FREQ'
        storeTime   = '&&OP0150'
        storeTimeNb = -storeTimeNb
        call wkvect(storeTime//'.VALE', 'V V R', storeTimeNb, vr = vStoreTime)
        call getvr8(' ', 'FREQ', nbval=storeTimeNb, vect=vStoreTime, nbret=nbOcc)
        goto 99
    endif
!
    call getvid(' ', 'LIST_FREQ', scal=storeTime, nbret=storeTimeNb)
    if (storeTimeNb .ne. 0) then
        storeAccess = 'LIST_FREQ'
        call jelira(storeTime//'.VALE', 'LONMAX', storeTimeNb)
        goto 99
    endif
!
 99 continue
!
! - Total number of storing index to crate
!
    if (storeTimeNb .ne. 0) then
        ASSERT(storeIndxNb .eq. 0)
        storeCreaNb = storeTimeNb
    endif
    if (storeIndxNb .ne. 0) then
        ASSERT(storeTimeNb .eq. 0)
        storeCreaNb = storeIndxNb
    endif
!
! - To select real
!
    if (storeTimeNb .ne. 0) then
        call getvtx(' ', 'CRITERE', scal=storeCrit, nbret=nbOcc)
        ASSERT(nbOcc .eq. 1)
        call getvr8(' ', 'PRECISION', scal=storeEpsi, nbret=nbOcc)
        ASSERT(nbOcc .eq. 1)
    endif
!
end subroutine
