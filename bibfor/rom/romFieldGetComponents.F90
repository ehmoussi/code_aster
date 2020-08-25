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
subroutine romFieldGetComponents(field)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/cmpcha.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jelira.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
type(ROM_DS_Field), intent(inout) :: field
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Get list of components in field
!
! --------------------------------------------------------------------------------------------------
!
! IO  field            : field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: physName
    character(len=19) :: pfchno
    character(len=24) :: fieldRefe
    character(len=4) :: fieldSupp
    integer :: nbEqua
    integer :: iEqua, nbLagr, numeCmp, nbCmpMaxi, cmpIndx
    integer, pointer :: deeq(:) => null()
    character(len=8), pointer :: physCmpName(:) => null()
    integer, pointer :: cataToField(:) => null()
    integer, pointer :: fieldToCata(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    field%lLagr     = ASTER_FALSE
    field%nbCmpName = 0
!
! - Get parameters from field
!
    fieldRefe = field%fieldRefe
    fieldSupp = field%fieldSupp
    nbEqua    = field%nbEqua
!
! - Get list of components on physical_quantities
!
    call dismoi('NOM_GD', fieldRefe, 'CHAMP', repk = physName)
    call jelira(jexnom('&CATA.GD.NOMCMP', physName), 'LONMAX', nbCmpMaxi)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', physName), 'L', vk8 = physCmpName)
!
! - Get name of compoenents and type of components (-1 if Lagrangian)
!
    if (fieldSupp == 'NOEU') then
! ----- Access to numbering
        call dismoi('PROF_CHNO' , fieldRefe, 'CHAM_NO', repk = pfchno)
        call jeveuo(pfchno//'.DEEQ', 'L', vi = deeq)
! ----- Allocate object for name of components
        AS_ALLOCATE(vk8 = field%listCmpName, size = nbCmpMaxi)
! ----- Allocate object for type of equation
        AS_ALLOCATE(vi = field%equaCmpName, size = nbEqua)
        nbLagr           = 0
        field%nbCmpName  = 0
        do iEqua = 1, nbEqua
            numeCmp = deeq(2*(iEqua-1)+2)
            if (numeCmp .gt. 0) then
                cmpIndx = indik8(field%listCmpName, physCmpName(numeCmp), 1, field%nbCmpName)
                if (cmpIndx .eq. 0) then
! ----------------- Add this name in the list
                    field%nbCmpName                    = field%nbCmpName + 1
                    field%listCmpName(field%nbCmpName) = physCmpName(numeCmp)
                    cmpIndx                            = field%nbCmpName
                endif
                field%equaCmpName(iEqua) = cmpIndx
            else
                nbLagr                   = nbLagr + 1
                field%equaCmpName(iEqua) = -1
            endif
        end do
        field%lLagr = nbLagr .gt. 0
    else if (fieldSupp == 'ELGA') then
! ----- Allocate object for name of components => in cmpcha
! ----- Allocate object for type of equation => in cmpcha
! ----- Create objects for global components (catalog) <=> local components (field)
        call cmpcha(fieldRefe, field%listCmpName, cataToField, fieldToCata, field%nbCmpName)
        AS_DEALLOCATE(vi = cataToField)
        AS_DEALLOCATE(vi = fieldToCata)
! ----- Cannot identify physical name on each equation for the moment
        AS_ALLOCATE(vi = field%equaCmpName, size = nbEqua)
        field%lLagr = ASTER_FALSE
        field%equaCmpName(1:nbEqua) = -1
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
