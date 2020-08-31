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
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/cmpcha.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utchdl.h"
#include "asterfort/utmess.h"
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
    integer :: ifm, niv
    character(len=8) :: physName, mesh, elemName, cmpName
    character(len=19) :: pfchno, ligrName
    character(len=24) :: fieldRefe
    character(len=4) :: fieldSupp
    integer :: iEqua, iGrel, iPt, iElem, iCmpName
    integer :: nbEqua, nbGrel, nbPt, nbElem, nbLagr, nbCmpMaxi, nbEquaCmp
    integer :: cmpNume, cmpIndx, elemNume, equaNume, locaNume, addr
    integer, pointer :: deeq(:) => null()
    character(len=8), pointer :: physCmpName(:) => null()
    integer, pointer :: cataToField(:) => null(), fieldToCata(:) => null()
    integer, pointer :: celd(:) => null(), modloc(:) => null(), liel(:) => null()
    real(kind=8), pointer :: celv(:) => null()
    aster_logical :: diff
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Initializations
!
    field%lLagr     = ASTER_FALSE
    field%nbCmpName = 0
!
! - Get parameters from field
!
    fieldRefe = field%fieldRefe
    fieldSupp = field%fieldSupp
    nbEqua    = field%nbEqua
    mesh      = field%mesh
    call dismoi('NOM_GD', fieldRefe, 'CHAMP', repk = physName)
!
! - Get list of components on physical_quantities
!
    call jelira(jexnom('&CATA.GD.NOMCMP', physName), 'LONMAX', nbCmpMaxi)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', physName), 'L', vk8 = physCmpName)
!
! - Allocate object for type of equation
!
    AS_ALLOCATE(vi = field%equaCmpName, size = nbEqua)
!
! - Get name of components and type of components (-1 if Lagrangian)
!
    if (fieldSupp == 'NOEU') then
! ----- Access to numbering
        call dismoi('PROF_CHNO' , fieldRefe, 'CHAM_NO', repk = pfchno)
        call jeveuo(pfchno//'.DEEQ', 'L', vi = deeq)

! ----- Detect equation
        AS_ALLOCATE(vk8 = field%listCmpName, size = nbCmpMaxi)
        nbLagr           = 0
        field%nbCmpName  = 0
        do iEqua = 1, nbEqua
            cmpNume = deeq(2*(iEqua-1)+2)
            if (cmpNume .gt. 0) then
                cmpIndx = indik8(field%listCmpName, physCmpName(cmpNume), 1, field%nbCmpName)
                if (cmpIndx .eq. 0) then
! ----------------- Add this name in the list
                    field%nbCmpName                    = field%nbCmpName + 1
                    field%listCmpName(field%nbCmpName) = physCmpName(cmpNume)
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
! ----- Access to field
        call dismoi('NOM_LIGREL', fieldRefe, 'CHAMP', repk = ligrName)
        call dismoi('NB_GREL', ligrName, 'LIGREL', repi = nbGrel)
        call jeveuo(fieldRefe(1:19)//'.CELD', 'L', vi = celd)
        call jeveuo(fieldRefe(1:19)//'.CELV', 'L', vr = celv)

! ----- Allocate object for name of components => in cmpcha
! ----- Allocate object for type of equation => in cmpcha
! ----- Create objects for global components (catalog) <=> local components (field)
        if (physName .eq. 'VARI_R') then
            nbCmpMaxi = celd(4)
            field%nbCmpName = nbCmpMaxi
            AS_ALLOCATE(vk8 = field%listCmpName, size = field%nbCmpName)
            do iCmpName = 1, field%nbCmpName
                field%listCmpName(iCmpName) = 'V'
                call codent(iCmpName, 'G', field%listCmpName(iCmpName)(2:8))
            end do
        else
            call cmpcha(fieldRefe, field%listCmpName, cataToField, fieldToCata, field%nbCmpName)
            AS_DEALLOCATE(vi = cataToField)
            AS_DEALLOCATE(vi = fieldToCata)
        endif

! ----- Detect equation
        do iGrel = 1, nbGrel
! --------- Local mode for the group ef elements (grel)
            locaNume = celd(celd(4+iGrel)+2)
            if (locaNume == 0) cycle

! --------- Get number of elements in GREL
            nbElem = celd(celd(4+iGrel)+1)

! --------- Get number of points (Gauss points) for each such element
            call jeveuo(jexnum('&CATA.TE.MODELOC', locaNume), 'L', vi = modloc)

! --------- Check: ELGA field only with constant number of components on each point
            ASSERT(modloc(1) == 3)
            diff = (modloc(4) .gt. 10000)
            ASSERT(.not. diff)
            nbPt = modloc(4)

! --------- Get list of elements
            call jeveuo(jexnum(ligrName(1:19)//'.LIEL', iGrel), 'L', vi = liel)

            do iElem = 1, nbElem
! ------------- Current element
                elemNume = liel(iElem)
                call jenuno(jexnum(mesh(1:8)//'.NOMMAI', elemNume), elemName)

! ------------- Adress in .CELV of the first field value for the element
                addr     = celd(celd(4+iGrel)+4+4*(iElem-1)+4)

                do iPt = 1, nbPt
                    do iCmpName = 1, field%nbCmpName
! --------------------- Get component name
                        cmpName = field%listCmpName(iCmpName)

! --------------------- Get the equation number for this component in field
                        call utchdl(fieldRefe, mesh, elemName, ' ', iPt,&
                                    1, iCmpName, cmpName, equaNume, nogranz = ASTER_TRUE)

! --------------------- Set equation
                        ASSERT(equaNume .gt. 0)
                        field%equaCmpName(equaNume) = iCmpName

                    end do
                end do
            end do
        end do

! ----- No Lagrange in ELGA fields !
        field%lLagr = ASTER_FALSE

    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Decompte
!
    do iCmpName = 1, field%nbCmpName
        nbEquaCmp = 0
        cmpName   = field%listCmpName(iCmpName)
        do iEqua = 1, nbEqua
            if (field%equaCmpName(iEqua) .eq. iCmpName) then
                nbEquaCmp = nbEquaCmp + 1
            endif
        end do
        if (niv .ge. 2) then
            call utmess('I', 'ROM11_3', si = nbEquaCmp, sk = cmpName)
        endif
    end do
!
end subroutine
