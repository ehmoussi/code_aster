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
subroutine utlicm(quantityName,&
                  cmpUserNb   , cmpUserName,&
                  cmpCataNb   , cmpCataName,&
                  cmpValidNb  , numcmp     ,&
                  ntncmp      , ntucmp)
!
implicit none
!
#include "asterfort/infniv.h"
#include "asterfort/assert.h"
#include "asterfort/irccmp.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in):: quantityName
integer, intent(in) :: cmpUserNb
character(len=8), pointer :: cmpUserName(:)
integer, intent(in) :: cmpCataNb
character(len=8), pointer :: cmpCataName(:)
integer, intent(out) :: cmpValidNb
character(len=*), intent(in) :: numcmp, ntncmp, ntucmp
!
! --------------------------------------------------------------------------------------------------
!
!     UTILITAIRE - CREATION D'UNE LISTE DE COMPOSANTES
!
! --------------------------------------------------------------------------------------------------
!
! In  quantityName     : name of physical quantity
! In  cmpUserNb        : number of components to select
!                         0 => all components
! Ptr cmpUserName      : pointer to list of names of components to select
! In  cmpCataNb        : maximum number of components in catalog
! Ptr cmpCataName      : pointer to the list of components in catalog
! Out cmpValidNb       : number of components selected
! In  numcmp           : name of JEVEUX object for index of components in physical quantity
! In  ntncmp           : name of JEVEUX object for name of components in physical quantity
! In  ntucmp           : name of JEVEUX object for unit of components in physical quantity
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, nivinf, iCmp
    integer, pointer :: cmpIndx(:) => null()
    character(len=16), pointer :: cmpValidName(:) => null()
    character(len=16), pointer :: cmpValidUnit(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, nivinf)
!
! - Allocate objects
!
    if (cmpUserNb .eq. 0) then
        cmpValidNb = cmpCataNb
    else if (cmpUserNb .gt. 0) then
        cmpValidNb = cmpUserNb
    else
        ASSERT(ASTER_FALSE)
    endif
    if (nivinf .gt. 1) then
        write (ifm,*) 'NOMBRE DE COMPOSANTES DEMANDEES : ', cmpValidNb
    endif
    call wkvect(numcmp, 'V V I', cmpValidNb, vi = cmpIndx)
!
! - Get index of user components in physical quantity
!
    if (cmpUserNb .eq. 0) then
        do iCmp = 1 , cmpValidNb
            cmpIndx(iCmp) = iCmp
        end do
    else
        call irccmp('A'       , quantityName,&
                    cmpCataNb , cmpCataName ,&
                    cmpUserNb , cmpUserName ,&
                    cmpValidNb, cmpIndx)
        if (cmpValidNb .ne. cmpUserNb) then
            call utmess('F', 'UTILITAI5_46', sk=quantityName)
        endif
    endif
!
! - Get names of physical components
!
    call wkvect(ntncmp, 'V V K16', cmpValidNb, vk16 = cmpValidName)
    call wkvect(ntucmp, 'V V K16', cmpValidNb, vk16 = cmpValidUnit)
    do iCmp = 1 , cmpValidNb
        cmpValidName(iCmp) = cmpCataName(cmpIndx(iCmp))
        cmpValidUnit(iCmp) = ' '
    end do
!
end subroutine
