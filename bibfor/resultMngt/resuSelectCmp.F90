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
subroutine resuSelectCmp(quantityIndx,&
                         cmpUserNb   , cmpUserName,&
                         cmpCataNb   , cmpCataName,&
                         cmpNb       , cmpIndx)
!
implicit none
!
#include "asterfort/irccmp.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/as_allocate.h"
!
integer, intent(in) :: quantityIndx
integer, intent(in) :: cmpUserNb
character(len=8), pointer :: cmpUserName(:)
integer, intent(out) :: cmpCataNb
character(len=8), pointer :: cmpCataName(:)
integer, intent(out) :: cmpNb
integer, pointer :: cmpIndx(:)
!
! --------------------------------------------------------------------------------------------------
!
! Result management
!
! Retrieve index of components in a physical quantity (by physical index)
!
! --------------------------------------------------------------------------------------------------
!
! In  quantityIndx     : index in catalog of physical quantity
! In  cmpUserNb        : number of components to select
! Ptr cmpUserName      : pointer to list of names of components to select
! Out cmpCataNb        : maximum number of components in catalog
! Ptr cmpCataName      : pointer to the list of components in catalog
! Out cmpNb            : number of components selected
!                        if zero => get all components
! Ptr cmpIndx          : pointer to index of selected components in physical quantity
!
! --------------------------------------------------------------------------------------------------
!
    character(len=1) :: errorType
    character(len=8) :: quantityName
!
! --------------------------------------------------------------------------------------------------
!
    cmpNb     = 0
    cmpCataNb = 0
    errorType = ' '
    call jenuno(jexnum('&CATA.GD.NOMGD', quantityIndx), quantityName)
    call jeveuo(jexnum('&CATA.GD.NOMCMP', quantityIndx), 'L', vk8 = cmpCataName)
    call jelira(jexnum('&CATA.GD.NOMCMP', quantityIndx), 'LONMAX', cmpCataNb)
    if (cmpUserNb .ne. 0 .and. quantityName .ne. 'VARI_R') then
        AS_ALLOCATE(vi = cmpIndx, size = cmpUserNb)
        call irccmp(errorType, quantityName,&
                    cmpCataNb, cmpCataName ,&
                    cmpUserNb, cmpUserName ,&
                    cmpNb    , cmpIndx)
    endif
    if (cmpUserNb .eq. 0) then
        cmpNb = 0
    endif
!
end subroutine
