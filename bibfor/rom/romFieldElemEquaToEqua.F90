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
subroutine romFieldElemEquaToEqua(fieldA, fieldB, equaAToB)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/jexnum.h"
#include "asterfort/dismoi.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utchdl.h"
!
type(ROM_DS_Field), intent(in) :: fieldA, fieldB
integer, pointer :: equaAToB(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create map for equation numbering from domain A to domain B - Elementary field
!
! --------------------------------------------------------------------------------------------------
!
! In  fieldA           : field (representative) on domain A
! In  fieldB           : field (representative) on domain B
! Ptr equaAToB         : pointer to map for equation numbering from domain A to domain B
!                          for iEquaA =  [1:nbEquaA]
!                              equaAToB[iEquaA] = 0 => this equation is not in domain B
!                              equaAToB[iEquaA] = numeEquaB => this equation is in domain B
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbEquaA, nbEquaB
    character(len=4) :: fieldSuppA, fieldSuppB
    integer :: iGrel, nbGrel, iElem, nbElem, iPt, nbPt, iCmpName, nbCmpName
    integer :: locaNume, elemNume, addr, numeEquaA, numeEquaB
    aster_logical :: diff
    character(len=19) :: ligrName
    character(len=24) :: fieldRefeA, fieldRefeB
    character(len=8) :: mesh, elemName, cmpName
    integer, pointer :: celd(:) => null()
    integer, pointer :: modloc(:) => null()
    integer, pointer :: liel(:) => null()
    real(kind=8), pointer :: celv(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM11_37')
    endif
!
! - Get parameters
!
    fieldRefeA = fieldA%fieldRefe
    fieldSuppA = fieldA%fieldSupp
    nbEquaA    = fieldA%nbEqua
    ASSERT(fieldSuppA .eq. 'ELGA')
    fieldRefeB = fieldB%fieldRefe
    fieldSuppB = fieldB%fieldSupp
    nbEquaB    = fieldB%nbEqua
    nbCmpName  = fieldB%nbCmpName
    ASSERT(fieldSuppB .eq. 'ELGA')
    call dismoi('NOM_LIGREL', fieldRefeB(1:19), 'CHAMP', repk = ligrName)
    call dismoi('NOM_MAILLA', ligrName, 'LIGREL', repk = mesh)
    call dismoi('NB_GREL', ligrName, 'LIGREL', repi = nbGrel)
    call jeveuo(fieldRefeB(1:19)//'.CELD', 'L', vi = celd)
    call jeveuo(fieldRefeB(1:19)//'.CELV', 'L', vr = celv)
!
! - Loop on field B
!
    numeEquaB = 0
    do iGrel = 1, nbGrel
! ----- Local mode for the group ef elements (grel)
        locaNume = celd(celd(4+iGrel)+2)
        if (locaNume == 0) cycle

! ----- Get number of elements in GREL
        nbElem = celd(celd(4+iGrel)+1)

! ----- Get number of points (Gauss points) for each such element
        call jeveuo(jexnum('&CATA.TE.MODELOC', locaNume), 'L', vi = modloc)

! ----- Check: ELGA field only with constant number of components on each point
        ASSERT(modloc(1) == 3)
        diff = (modloc(4) .gt. 10000)
        ASSERT(.not. diff)
        nbPt = modloc(4)

! ----- Get list of elements
        call jeveuo(jexnum(ligrName(1:19)//'.LIEL', iGrel), 'L', vi = liel)

        do iElem = 1, nbElem
! --------- Current element
            elemNume = liel(iElem)
            call jenuno(jexnum(mesh(1:8)//'.NOMMAI', elemNume), elemName)

! --------- Adress in .CELV of the first field value for the element
            addr = celd(celd(4+iGrel)+4+4*(iElem-1)+4)

            do iPt = 1, nbPt
                do iCmpName = 1, nbCmpName
! ----------------- Get component name
                    cmpName = fieldB%listCmpName(iCmpName)

! ----------------- Get the equation number for this component in field A
                    call utchdl(fieldRefeA, mesh, elemName, ' ', iPt,&
                                1, 0, cmpName, numeEquaA, nogranz = ASTER_TRUE)

! ----------------- Set equation numbering
                    ASSERT(numeEquaA .gt. 0)
                    numeEquaB = numeEquaB + 1
                    ASSERT(numeEquaA .le. nbEquaA)
                    ASSERT(numeEquaB .le. nbEquaB)
                    equaAToB(numeEquaA) = numeEquaB

                end do
            end do
        end do
    end do
!
end subroutine
