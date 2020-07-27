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
subroutine romGetListComponents(fieldRefe  , fieldSupp  , nbEqua,&
                                equaCmpName, listCmpName,&
                                nbCmp      , lLagr)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jelira.h"
#include "asterfort/as_allocate.h"
!
character(len=24), intent(in) :: fieldRefe
character(len=4), intent(in) :: fieldSupp
integer, intent(in) :: nbEqua
integer, pointer :: equaCmpName(:)
character(len=8), pointer :: listCmpName(:)
integer, intent(out) :: nbCmp
aster_logical, intent(out) :: lLagr
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get list of components in field
!
! --------------------------------------------------------------------------------------------------
!
! In  fieldRefe        : field to analyze
! In  fieldSupp        : cell support of field (NOEU, ELNO, ELEM, ...)
! In  nbEequa          : number of equations (length of empiric mode)
! Ptr equaCmpName      : pointer to the index of name (in listCmpName) for each dof
! Ptr listCmpName      : pointer to the list of name of compoenents
! Out nbCmp            : length of v_list_type
! Out lLagr            : flag if vector contains at least one Lagrange multiplier
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: physName
    character(len=19) :: pfchno
    integer :: iEqua, nbLagr, cmpNume, nbCmpMaxi, cmpIndx
    integer, pointer :: deeq(:) => null()
    character(len=8), pointer :: physCmpName(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    lLagr = ASTER_FALSE
    nbCmp = 0
!
! - Get list of components on physical_quantities
!
    call dismoi('NOM_GD', fieldRefe, 'CHAMP', repk = physName)
    call jelira(jexnom('&CATA.GD.NOMCMP', physName), 'LONMAX', nbCmpMaxi)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', physName), 'L', vk8 = physCmpName)
!
! - Allocate object for type of equation
!
    AS_ALLOCATE(vi = equaCmpName, size = nbEqua)
!
! - Get name of compoenents and type of components (-1 if Lagrangian)
!
    if (fieldSupp == 'NOEU') then
! ----- Access to numbering
        call dismoi('PROF_CHNO' , fieldRefe, 'CHAM_NO', repk = pfchno)
        call jeveuo(pfchno//'.DEEQ', 'L', vi = deeq)
! ----- Allocate object for name of components
        AS_ALLOCATE(vk8 = listCmpName, size = nbCmpMaxi)
        nbLagr = 0
        nbCmp  = 0
        do iEqua = 1, nbEqua
            cmpNume = deeq(2*(iEqua-1)+2)
            if (cmpNume .gt. 0) then
                cmpIndx = indik8(listCmpName, physCmpName(cmpNume), 1, nbCmp)
                if (cmpIndx .eq. 0) then
! ----------------- Add this name in the list
                    nbCmp              = nbCmp + 1
                    listCmpName(nbCmp) = physCmpName(cmpNume)
                    cmpIndx            = nbCmp
                endif
                equaCmpName(iEqua) = cmpIndx
            else
                nbLagr             = nbLagr + 1
                equaCmpName(iEqua) = -1
            endif
        end do
        lLagr = nbLagr .gt. 0
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
