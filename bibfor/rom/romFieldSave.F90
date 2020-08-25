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
subroutine romFieldSave(operation, resultName, numeStore,&
                        field    , fieldValeC_,&
                        nbEquaR_ , equaCToR_  , fieldValeR_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/copisd.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
!
character(len=*), intent(in) :: operation
character(len=8), intent(in) :: resultName
integer, intent(in) :: numeStore
type(ROM_DS_Field), intent(in) :: field
real(kind=8), optional, pointer :: fieldValeC_(:)
integer, optional, intent(in) :: nbEquaR_
integer, optional, pointer :: equaCToR_(:)
real(kind=8), optional, pointer :: fieldValeR_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Save field in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  operation        : operation
!                        'SetToZero' set zero on complete domain
!                        'Copy'      copy values on complete domain
!                        'Partial'   copy values with two fields
!                                    1/ One complete field
!                                    2/ One field on restricted domain (in general, more accurate)
! In  resultName       : name of results datastructure
! In  numeStore        : index to store field in results datastructure
! In  field            : field to save
! Ptr fieldValeC       : pointer for values of field on complete domain
! In  nbEquaR          : number of equations on restricted domain
! Ptr equaCToR         : pointer to convert index of equation from complete domain to 
!                        restricted domain
! Ptr fieldValeR       : pointer for values of field on restricted domain
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nbEqua, iEqua, equaNume, nbEquaRead
    character(len=24) :: resultField
    real(kind=8), pointer :: valeWrite(:) => null()
    character(len=24) :: fieldRefe, fieldName
    character(len=4) :: fieldSupp
!
! --------------------------------------------------------------------------------------------------
!
    fieldRefe = field%fieldRefe
    fieldName = field%fieldName
    fieldSupp = field%fieldSupp
    nbEqua    = field%nbEqua
!
! - Get field in output results datastructure
!
    call rsexch(' '      , resultName , fieldName,&
                numeStore, resultField, iret)
    ASSERT(iret .eq. 100)
!
! - Copy structure of field to save it
!
    call copisd('CHAMP_GD', 'G', fieldRefe, resultField)
    if (fieldSupp .eq. 'NOEU') then
        call jeveuo(resultField(1:19)//'.VALE', 'E', vr = valeWrite)
        call jelira(resultField(1:19)//'.VALE', 'LONMAX', nbEquaRead)
    elseif (fieldSupp .eq. 'ELGA') then
        call jeveuo(resultField(1:19)//'.CELV', 'E', vr = valeWrite)
        call jelira(resultField(1:19)//'.CELV', 'LONMAX', nbEquaRead)
    else
        ASSERT(ASTER_FALSE)
    endif
    ASSERT(nbEqua .eq. nbEquaRead)
!
! - Set value in field
!
    if (operation .eq. 'SetToZero') then
        do iEqua = 1, nbEqua
            valeWrite(iEqua) = 0.d0
        end do

    elseif (operation .eq. 'Copy') then
        do iEqua = 1, nbEqua
            valeWrite(iEqua) = fieldValeC_(iEqua)
        end do

    elseif (operation .eq. 'Partial') then
        ASSERT(nbEqua .ge. nbEquaR_)
        do iEqua = 1, nbEqua
            equaNume = equaCToR_(iEqua)
            if (equaNume .eq. 0) then
                valeWrite(iEqua) = fieldValeC_(iEqua)
            else
                valeWrite(iEqua) = fieldValeR_(equaNume)
            endif
        enddo

    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Notification in results datastructure
!
    call rsnoch(resultName, fieldName, numeStore)
!
end subroutine
