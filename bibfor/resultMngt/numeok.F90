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
subroutine numeok(storeAccess,&
                  storeIndxNb, storeTimeNb,&
                  storeIndx  , storeTime  ,&
                  storeCrit  , storeEpsi  ,&
                  fileIndx   , fileTime   ,&
                  astock)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jeveuo.h"
!
character(len=10), intent(in) :: storeAccess
integer, intent(in) :: storeIndxNb, storeTimeNb
character(len=19), intent(in) :: storeIndx, storeTime
real(kind=8), intent(in) :: storeEpsi
character(len=8), intent(in) :: storeCrit
integer, intent(in) :: fileIndx
real(kind=8), intent(in) :: fileTime
aster_logical, intent(out) :: astock
!
! --------------------------------------------------------------------------------------------------
!
! IDEAS reader
!
! Check if field from file is in the selection list
!
! --------------------------------------------------------------------------------------------------
!
! In  storeAccess      : how to access to the storage
! In  storeIndxNb      : number of storage slots given by index (integer)
! In  storeIndx        : name of JEVEUX object to access storage slots given by index (integer)
! In  storeTimeNb      : number of storage slots given by time/freq (real)
! In  storeTime        : name of JEVEUX object to access storage slots given by time/freq (real)
! In  storeEpsi        : tolerance to find time/freq (real)
! In  storeCrit        : type of tolerance to find time/freq (real)
! In  fileTime         : value of storing (time) read in file
! In  fileIndx         : value of storing (index) read in file
! Out astock           : flag if this field is in the storing list give by user
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: tref
    integer :: iStore
    integer, pointer :: vStoreIndx(:) => null()
    real(kind=8), pointer :: vStoreTime(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    astock = .false.
!
    if (storeAccess .eq. 'TOUT_ORDRE') then
        astock = .true.
    elseif (storeAccess .eq. 'NUME_ORDRE') then
        call jeveuo(storeIndx//'.VALE', 'L', vi = vStoreIndx)
        do iStore = 1, storeIndxNb
            if (fileIndx .eq. vStoreIndx(iStore)) then
                astock = .true.
                goto 70
            endif
        end do
    else
        call jeveuo(storeTime//'.VALE', 'L', vr = vStoreTime)
        do iStore = 1, storeTimeNb
            tref = vStoreTime(iStore)
            if (storeCrit .eq. 'RELATIF') then
                if (abs(tref-fileTime) .le. abs(storeEpsi*fileTime)) then
                    astock = .true.
                    goto 70
                endif
            else if (storeCrit .eq. 'ABSOLU') then
                if (abs(tref-fileTime) .le. abs(storeEpsi)) then
                    astock = .true.
                    goto 70
                endif
            endif
        end do
    endif
!
 70 continue
!
end subroutine
