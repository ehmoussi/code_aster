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
subroutine rsSelectStoringIndex(resultZ, lFromField ,&
                                nbStore, numeStoreJv, timeStoreJv)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rsorac.h"
#include "asterfort/wkvect.h"
!
character(len=*), intent(in) :: resultZ
aster_logical, intent(in) :: lFromField
integer, intent(out) :: nbStore
character(len=24), intent(out) :: numeStoreJv, timeStoreJv
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Select storing index from user
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8) :: cdummy
    character(len=19) :: listTime, listNume
    integer :: iret, jvPara, iStore, tord(1)
    real(kind=8) :: time, prec
    aster_logical :: lSelectByIndex
    character(len=8) :: kdummy, crit
    integer:: keywNbTime, keywNbTimeList, keywNbStore, keywNbStoreList
    integer, pointer :: listNumeStore(:) => null()
    real(kind=8), pointer :: listTimeStore(:) => null()
    integer, pointer :: listNumeRead(:) => null()
    real(kind=8), pointer :: listTimeRead(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nbStore        = 0
    lSelectByIndex = ASTER_FALSE
    numeStoreJv    = '&&RSSELE.NUME_STORE'
    timeStoreJv    = '&&RSSELE.TIME_STORE'
!
! - Get parameters
!
    call getvr8(' ', 'PRECISION' , scal=prec)
    call getvtx(' ', 'CRITERE'   , scal=crit)
    call getvr8(' ', 'INST'      , nbval=0, nbret=keywNbTime)
    call getvis(' ', 'NUME_ORDRE', nbval=0, nbret=keywNbStore)
    call getvid(' ', 'LIST_INST' , nbval=0, nbret=keywNbTimeList)
    call getvid(' ', 'LIST_ORDRE', nbval=0, nbret=keywNbStoreList)

    if (lFromField) then
        nbStore          = 1
        call wkvect(numeStoreJv, 'V V I', nbStore, vi = listNumeStore)
        listNumeStore(1) = 1
        lSelectByIndex   = ASTER_TRUE
    else
! ----- From list of time index
        if (keywNbTime .ne. 0) then
            nbStore     = - keywNbTime
            call wkvect(timeStoreJv, 'V V R', nbStore, vr = listTimeStore)
            call getvr8(' ', 'INST', nbval = nbStore, vect = listTimeStore, nbret = iret)
        endif
        if (keywNbTimeList .ne. 0) then
            call getvid(' ', 'LIST_INST', scal = listTime, nbret = iret)
            call jeveuo(listTime(1:19)//'.VALE', 'L', vr = listTimeRead)
            call jelira(listTime(1:19)//'.VALE', 'LONMAX', nbStore)
            call wkvect(timeStoreJv, 'V V R', nbStore, vr = listTimeStore)
            listTimeStore(1:nbStore) = listTimeRead(1:nbStore)
        endif

! ----- From list of storing index
        if (keywNbStore .ne. 0) then
            lSelectByIndex = ASTER_TRUE
            nbStore        = -keywNbStore
            call wkvect(numeStoreJv, 'V V I', nbStore, vi = listNumeStore)
            call getvis(' ', 'NUME_ORDRE', nbval = nbStore, vect = listNumeStore, nbret = iret)
        endif
        if (keywNbStoreList .ne. 0) then
            lSelectByIndex = ASTER_TRUE
            call getvid(' ', 'LIST_ORDRE', scal = listNume, nbret = iret)
            call jeveuo(listNume(1:19)//'.VALE', 'L', vi = listNumeRead)
            call jelira(listNume(1:19)//'.VALE', 'LONMAX', nbStore)
            call wkvect(numeStoreJv, 'V V I', nbStore, vi = listNumeStore)
            listNumeStore(1:nbStore) = listNumeRead(1:nbStore)
        endif

! ----- All storing index
        if (keywNbStoreList+keywNbTimeList+keywNbStore+keywNbTime .eq. 0) then
            lSelectByIndex = ASTER_TRUE
            call rs_get_liststore(resultZ, nbStore)
            if (nbStore .ne. 0) then
                call wkvect(numeStoreJv, 'V V I', nbStore, vi = listNumeStore)
                call rs_get_liststore(resultZ, nbStore, listNumeStore)
            endif
        endif
    endif
!
! - Create objects
!
    if (lSelectByIndex) then
        call wkvect(timeStoreJv, 'V V R', nbStore, vr = listTimeStore)
    else
        call wkvect(numeStoreJv, 'V V I', nbStore, vi = listNumeStore)
    endif
!
! - Prepare list of time store
!
    do iStore = 1, nbStore
        if (lSelectByIndex) then
            if (.not. lFromField) then
                call rsadpa(resultZ, 'L', 1, 'INST', listNumeStore(iStore), 0, sjv=jvPara)
                listTimeStore(iStore) = zr(jvPara)
            endif
        else
            time = listTimeStore(iStore)
            call rsorac(resultZ, 'INST', 0   , time, kdummy,&
                        cdummy , prec  , crit, tord, 1     ,&
                        iret)
            listNumeStore(iStore) = tord(1)
        endif
    end do
!
end subroutine
