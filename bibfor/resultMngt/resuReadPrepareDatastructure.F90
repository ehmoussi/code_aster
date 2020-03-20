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
subroutine resuReadPrepareDatastructure(resultName , resultType , lReuse,&
                                        storeIndxNb, storeTimeNb,&
                                        storeIndx  , storeTime  ,&
                                        storeCreaNb, storePara)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsagsd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/resuReadGetStorePara.h"
#include "asterfort/utmess.h"
#include "asterfort/rs_getlast.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rsGetSize.h"
!
character(len=8), intent(in) :: resultName
character(len=16), intent(in) :: resultType
aster_logical, intent(in) :: lReuse
integer, intent(in) :: storeIndxNb, storeTimeNb
character(len=19), intent(in) :: storeIndx, storeTime
integer, intent(out) :: storeCreaNb
character(len=4), intent(out) :: storePara
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Prepare datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  resultType       : type of results datastructure (EVOL_NOLI, EVOL_THER, )
! In  lReuse           : flag if reuse 
! In  storeIndxNb      : number of storage slots given by index (integer)
! In  storeTimeNb      : number of storage slots given by time/freq (real)
! In  storeIndx        : name of JEVEUX object to access storage slots given by index (integer)
! In  storeTime        : name of JEVEUX object to access storage slots given by time/freq (real)
! Out storeCreaNb      : number of storage slots to create
! Out storePara        : name of parameter to access results (INST or FREQ)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: storeLastIndx, resultSize, resultSizeMaxi
    real(kind=8) :: storeLastTime
    integer, pointer :: vStoreIndx(:) => null()
    real(kind=8), pointer :: vStoreTime(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    storeCreaNb = 0
    storePara   = ' '
!
! - Number of storing index to create
!
    if ((storeTimeNb .eq. 0) .and. (storeTimeNb .eq. 0)) then
        storeCreaNb = 100
    endif
    if (storeTimeNb .ne. 0) then
        ASSERT(storeIndxNb .eq. 0)
        storeCreaNb = storeTimeNb
    endif
    if (storeIndxNb .ne. 0) then
        ASSERT(storeTimeNb .eq. 0)
        storeCreaNb = storeIndxNb
    endif
!
    if (lReuse) then
! ----- Name of parameter for storage
        call resuReadGetStorePara(resultName, storePara)
! ----- Get last saved store
        if (storePara .eq. 'INST') then
            call rs_getlast(resultName, storeLastIndx, storeLastTime)
        elseif (storePara .eq. 'FREQ') then
            call rs_getlast(resultName, storeLastIndx, freq_last = storeLastTime)
        else
            ASSERT(ASTER_FALSE)
        endif
        if ((storeTimeNb .eq. 0) .and. (storeIndxNb .eq. 0)) then
            call utmess('F', 'RESULT2_19')
        endif
        if (storeTimeNb .ne. 0) then
            call jeveuo(storeTime//'.VALE', 'L', vr = vStoreTime)
            if (vStoreTime(1) .le. storeLastTime) then
                if (storePara .eq. 'INST') then
                    call utmess('F', 'RESULT2_20', nr = 2, valr = [storeLastTime, vStoreTime(1)])
                elseif (storePara .eq. 'FREQ') then
                    call utmess('F', 'RESULT2_21', nr = 2, valr = [storeLastTime, vStoreTime(1)])
                else
                    ASSERT(ASTER_FALSE)
                endif
            endif
        endif
        if (storeIndxNb .ne. 0) then
            call jeveuo(storeIndx//'.VALE', 'L', vi = vStoreIndx)
            if (vStoreIndx(1) .le. storeLastIndx) then
                call utmess('F', 'RESULT2_22', ni = 2, vali = [storeLastIndx, vStoreIndx(1)])
            endif
        endif
! ----- Is it enough for new fields ?
        call rs_get_liststore(resultName, resultSize)
        call rsGetSize(resultName, resultSizeMaxi)
        if ((resultSize + storeCreaNb) .gt.  resultSizeMaxi) then
            call rsagsd(resultName, 0)
        endif
    else
! ----- Create results datastructures
        call rscrsd('G', resultName, resultType, storeCreaNb)
! ----- Name of parameter for storage
        call resuReadGetStorePara(resultName, storePara)
    endif
!
end subroutine
