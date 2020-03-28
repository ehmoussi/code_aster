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

subroutine irccmp(errorType, quantityName,&
                  cmpCataNb, cmpCataName ,&
                  cmpUserNb, cmpUserName ,&
                  cmpNb    , cmpIndx)
!
implicit none
!
#include "asterfort/utmess.h"
!
character(len=1), intent(in) :: errorType
character(len=8), intent(in):: quantityName
integer, intent(in) :: cmpCataNb
character(len=8), pointer :: cmpCataName(:)
integer, intent(in) :: cmpUserNb
character(len=8), pointer :: cmpUserName(:)
integer, intent(out) :: cmpNb
integer, pointer :: cmpIndx(:)
!
! --------------------------------------------------------------------------------------------------
!
! Result management
!
! Retrieve index of components in a physical quantity (by physical name)
!
! --------------------------------------------------------------------------------------------------
!
! In  errorType        : what to do when component doesn't exist in physical quantity
! In  quantityName     : name of physical quantity
! In  cmpCataNb        : maximum number of components in catalog
! Ptr cmpCataName      : pointer to the list of components in catalog
! In  cmpUserNb        : number of components to select
! Ptr cmpUserName      : pointer to list of names of components to select
! Out cmpNb            : number of components selected
! Ptr cmpIndx          : pointer to index of selected components in physical quantity
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iCmpUser, iCmpCata
!
! --------------------------------------------------------------------------------------------------
!
    cmpNb = 0
    do iCmpUser = 1, cmpUserNb
        do iCmpCata = 1, cmpCataNb
            if (cmpUserName(iCmpUser) .eq. cmpCataName(iCmpCata)) then
                cmpNb          = cmpNb + 1
                cmpIndx(cmpNb) = iCmpCata
                goto 10
            endif
        end do
        if (errorType .ne. ' ') then
            call utmess(errorType, 'RESULT3_25',&
                        nk=2, valk=[cmpUserName(iCmpUser), quantityName])
        endif
10      continue
    end do
!
end subroutine
