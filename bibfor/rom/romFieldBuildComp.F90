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
subroutine romFieldBuildComp(resultDomNameZ, resultRomNameZ,&
                             nbStore       , fieldBuild)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/romFieldSave.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: resultDomNameZ, resultRomNameZ
integer, intent(in) :: nbStore
type(ROM_DS_FieldBuild), intent(in) :: fieldBuild
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field build
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! In  resultDomName    : name of complete results datastructure
! In  resultRomName    : name of reduced results datastructure
! In  nbStore          : number of storing index
! In  fieldBuild       : field to reconstruct
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: numeStoreInit = 0
    aster_logical :: lRIDTrunc
    character(len=24) :: fieldName, resultField
    integer :: iStore, iEqua
    integer :: numeStore, iret, numeEqua
    integer :: nbEquaDom, nbEquaRID, nbEquaRIDTotal
    real(kind=8), pointer :: valeRom(:) => null(), valeDom(:) => null()
    real(kind=8), pointer :: valeField(:) => null()
    type(ROM_DS_Field) :: fieldDom
    character(len=4) :: fieldSupp
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    fieldDom       = fieldBuild%fieldDom
    fieldName      = fieldDom%fieldName
    fieldSupp      = fieldDom%fieldSupp
    nbEquaDom      = fieldDom%nbEqua
    lRIDTrunc      = fieldBuild%lRIDTrunc
    nbEquaRID      = fieldBuild%nbEquaRID
    nbEquaRIDTotal = fieldBuild%nbEquaRIDTotal
!
! - Debug print
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM17_7', sk = fieldName)
    endif
!
! - Save zero vector for initial state
!
    call romFieldSave('SetToZero', resultDomNameZ, numeStoreInit, fieldBuild%fieldDom)
!
! - Preallocate
!
    AS_ALLOCATE(vr = valeRom, size = nbEquaRID)
    AS_ALLOCATE(vr = valeDom, size = nbEquaDom)
!
! - Compute fields
!
    do iStore = 1, nbStore-1
        numeStore = iStore

! ----- Get field from reduced model
        call rsexch(' '      , resultRomNameZ, fieldName,&
                    numeStore, resultField   , iret)
        ASSERT(iret .eq. 0)
        if (fieldSupp .eq. 'NOEU') then
            call jeveuo(resultField(1:19)//'.VALE', 'L', vr = valeField)
        elseif (fieldSupp .eq. 'ELGA') then
            call jeveuo(resultField(1:19)//'.CELV', 'L', vr = valeField)
        else
            ASSERT(ASTER_FALSE)
        endif

! ----- Truncate if required
        if (lRIDTrunc) then
            ASSERT(nbEquaRID .le. nbEquaRIDTotal)
            do iEqua = 1, nbEquaRIDTotal
                numeEqua = fieldBuild%equaRIDTrunc(iEqua)
                if (numeEqua .ne. 0) then
                    valeRom(numeEqua) = valeField(iEqua)
                endif
            end do
        else
            do iEqua = 1, nbEquaRID
                valeRom(iEqua) = valeField(iEqua)
            end do
        endif

! ----- Get reconstructed field from transient
        do iEqua = 1, nbEquaDom
            valeDom(iEqua) = fieldBuild%fieldTransientVale(iEqua+nbEquaDom*(numeStore-1))
        enddo

! ----- Save field in results datastructure
        call romFieldSave('Partial'           , resultDomNameZ, numeStore,&
                          fieldDom, valeDom,&
                          fieldBuild%nbEquaRID, fieldBuild%equaRIDTotal, valeRom)

    end do
!
! - Clean
!
    AS_DEALLOCATE(vr = valeRom)
    AS_DEALLOCATE(vr = valeDom)
!
end subroutine
