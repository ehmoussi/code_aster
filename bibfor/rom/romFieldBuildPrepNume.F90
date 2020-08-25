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
subroutine romFieldBuildPrepNume(mesh      , nbNodeMesh, listNode,&
                                 fieldBuild)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/romFieldNodeEquaToEqua.h"
#include "asterfort/romFieldElemEquaToEqua.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
integer, intent(in) :: nbNodeMesh
integer, pointer  :: listNode(:)
type(ROM_DS_FieldBuild), intent(inout) :: fieldBuild
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field build
!
! Prepare link between numbering
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : mesh
! In  nbNodeMesh       : number of nodes in mesh
! Ptr listNode         : pointer to list of nodes in mesh for selection
! IO  fieldBuild       : field to reconstruct
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_Field) :: fieldDom, fieldRom
    aster_logical :: lRIDTrunc
    character(len=24) :: grNodeRIDInterface
    character(len=4) :: fieldSupp
    integer :: iNodeGrno, iCmpName, iEquaDom
    integer, pointer :: grno(:) => null(), grnoInDom(:) => null()
    integer :: nbCmpName, nbEquaDom, nbEquaRom, nbNodeGrno
    integer :: nord, noeq, numeEquaRom, numeEquaDom
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM17_2')
    endif
!
! - Get parameters
!
    fieldRom           = fieldBuild%fieldRom
    fieldDom           = fieldBuild%fieldDom
    fieldSupp          = fieldBuild%fieldRom%fieldSupp
    lRIDTrunc          = fieldBuild%lRIDTrunc
    grNodeRIDInterface = fieldBuild%grNodeRIDInterface
    nbCmpName          = fieldDom%nbCmpName
    nbEquaDom          = fieldDom%nbEqua
    nbEquaRom          = fieldRom%nbEqua
!
! - Allocate map for equations numbering from complete domain to reduced domain
!
    AS_ALLOCATE(vi = fieldBuild%equaRIDTotal, size = nbEquaDom)
!
! - Create map for equations numbering from complete domain to reduced domain
!
    if (fieldSupp .eq. 'NOEU') then
        call romFieldNodeEquaToEqua(fieldDom, fieldRom, nbNodeMesh, listNode,&
                                    fieldBuild%equaRIDTotal)
    elseif (fieldSupp .eq. 'ELGA') then
        call romFieldElemEquaToEqua(fieldDom, fieldRom, fieldBuild%equaRIDTotal)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Total number of equations in RID
!
    fieldBuild%nbEquaRIDTotal = nbEquaRom
!
! - Numbering for partial RID
!
    if (lRIDTrunc) then
        ASSERT(fieldSupp .eq. 'NOEU')
! ----- Access to GROUP_NO at interface
        call jelira(jexnom(mesh//'.GROUPENO', grNodeRIDInterface), 'LONUTI', nbNodeGrno)
        call jeveuo(jexnom(mesh//'.GROUPENO', grNodeRIDInterface), 'L'     , vi = grno)

! ----- Create list of equations at interface
        ASSERT(nbCmpName*nbNodeGrno .le. nbEquaDom)
        AS_ALLOCATE(vi = grnoInDom, size = nbEquaDom)
        do iNodeGrno = 1, nbNodeGrno
            do iCmpName = 1, nbCmpName
                grnoInDom(iCmpName+nbCmpName*(grno(iNodeGrno)-1)) = 1
            enddo
        enddo

! ----- Create list of index of equations in RID_Trunc
        AS_ALLOCATE(vi = fieldBuild%equaRIDTrunc, size = nbEquaDom)
        noeq = 0
        nord = 0

        if (fieldSupp .eq. 'NOEU') then
            do iEquaDom = 1, nbEquaDom
                numeEquaDom = iEquaDom
                numeEquaRom = fieldBuild%equaRIDTotal(numeEquaDom)
                if (numeEquaRom .ne. 0) then
! ----------------- This equation is in RID
                    nord = nord + 1
                    if (grnoInDom(numeEquaDom) .eq. 0) then
! --------------------- This equation is not at interface
                        noeq = noeq + 1
                        fieldBuild%equaRIDTotal(numeEquaDom) = noeq
                        fieldBuild%equaRIDTrunc(nord)        = noeq
                    else
! --------------------- This equation is at interface
                        fieldBuild%equaRIDTotal(numeEquaDom) = 0
                    endif
                endif
            enddo
        elseif (fieldSupp .eq. 'ELGA') then
            do iEquaDom = 1, nbEquaDom
                numeEquaDom = iEquaDom
                numeEquaRom = fieldBuild%equaRIDTotal(numeEquaDom)
                if (numeEquaRom .ne. 0) then
                    noeq = noeq + 1
                    fieldBuild%equaRIDTotal(numeEquaDom) = noeq
                    fieldBuild%equaRIDTrunc(numeEquaDom) = noeq
                endif
            end do
            ASSERT(noeq .eq. nbEquaRom)
        else
            ASSERT(ASTER_FALSE)
        endif

! ----- Final size
        if (fieldSupp .eq. 'NOEU') then
            fieldBuild%nbEquaRIDTrunc = fieldBuild%nbEquaRIDTotal - nbNodeGrno*nbCmpName
        elseif (fieldSupp .eq. 'ELGA') then
            fieldBuild%nbEquaRIDTrunc = fieldBuild%nbEquaRIDTotal
        else
            ASSERT(ASTER_FALSE)
        endif

! ----- Clean
        AS_DEALLOCATE(vi = grnoInDom)
    endif
!
! - Effective number of equation in RID
!
    if (lRIDTrunc) then
        fieldBuild%nbEquaRID = fieldBuild%nbEquaRIDTrunc
    else
        fieldBuild%nbEquaRID = fieldBuild%nbEquaRIDTotal
    endif
!
! - Reinitialization of list of nodes
!
    listNode = 0
!
end subroutine
