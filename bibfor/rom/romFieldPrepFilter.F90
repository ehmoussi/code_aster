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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romFieldPrepFilter(nbCmpToFilter, cmpToFilter,&
                              field)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: nbCmpToFilter
character(len=8), pointer :: cmpToFilter(:)
type(ROM_DS_Field), intent(inout) :: field
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Prepare filter for components
!
! --------------------------------------------------------------------------------------------------
!
! In  nbCmpToFilter    : number of components to filter
! Ptr cmpToFilter      : pointer to the components to filter
! IO  field            : field
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lFilter, lFound
    integer :: iCmpToFilter, iCmpName, iEqua
    integer :: nbCmpName, nbEqua
    integer :: cmpNume
    character(len=8) :: cmpName, cmpFilterName
    integer, pointer :: cmpRefe(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    lFilter = ASTER_FALSE
!
! - Get properties of field
!
    nbEqua    = field%nbEqua
    nbCmpName = field%nbCmpName
!
! - Allocate selection
!
    AS_ALLOCATE(vi = field%equaFilter, size = nbEqua)
!
! - Check list of components
!
    if (nbCmpToFilter .gt. 0) then
        lFilter = ASTER_TRUE
        AS_ALLOCATE(vi = cmpRefe, size = nbCmpToFilter)
        do iCmpToFilter = 1, nbCmpToFilter
            cmpFilterName = cmpToFilter(iCmpToFilter)
            lFound        = ASTER_FALSE
            do iCmpName = 1, nbCmpName
                cmpName = field%listCmpName(iCmpName)
                if (cmpFilterName .eq. cmpName) then
                    lFound = ASTER_TRUE
                    exit
                endif
            end do
            if (lFound) then
                cmpRefe(iCmpToFilter) = iCmpName
            else
                call utmess('F', 'ROM11_2', sk = cmpFilterName)
            endif   
        end do
    endif
!
! - Select equations
!
    if (lFilter) then
        do iCmpToFilter = 1, nbCmpToFilter
            cmpFilterName = cmpToFilter(iCmpToFilter)
            cmpNume       = cmpRefe(iCmpToFilter)
            do iEqua = 1, nbEqua
                if (field%equaCmpName(iEqua) .eq. cmpNume .and. cmpNume .ne. 0) then
                    field%equaFilter(iEqua) = 1
                endif
            end do
        end do
    else
        field%equaFilter = 1
    endif
!
! - Save parameters
!
    field%lFilter = lFilter
!
! - Clean
!
    AS_DEALLOCATE(vi = cmpRefe)
!
end subroutine
