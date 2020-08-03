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
subroutine romFieldGetInfo(model, fieldName, fieldRefe, field, l_chck_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jelira.h"
#include "asterfort/romGetListComponents.h"
#include "asterfort/romFieldChck.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in)        :: model
character(len=24), intent(in)       :: fieldRefe, fieldName
type(ROM_DS_Field), intent(inout)   :: field
aster_logical, optional, intent(in) :: l_chck_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get informations from field
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  fieldName        : name of field (NOM_CHAM)
! In  fieldRefe        : field to analyse
! IO  field            : field
! In  l_chck           : flag to check components
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbEqua, nbCmp
    character(len=8) :: mesh
    character(len=4) :: fieldSupp
    aster_logical :: lLagr, l_chck
!
! --------------------------------------------------------------------------------------------------
!
    l_chck = ASTER_TRUE
    if (present(l_chck_)) then
        l_chck = l_chck_
    endif
!
! - Initializations
!
    lLagr      = ASTER_FALSE
    fieldSupp  = ' '
    nbEqua     = 0
    nbCmp      = 0
!
! - Get main parameters
!
    call dismoi('NOM_MAILLA', model, 'MODELE' , repk = mesh)
    call dismoi('TYPE_CHAMP', fieldRefe, 'CHAMP', repk = fieldSupp)
    if (fieldSupp .eq. 'NOEU') then
        call dismoi('NB_EQUA', fieldRefe, 'CHAM_NO', repi = nbEqua)
    elseif (fieldSupp .eq. 'ELGA') then
        call jelira(fieldRefe(1:19)//'.CELV', 'LONUTI', nbEqua)
    else
        call utmess('F', 'ROM3_1', sk = fieldSupp)
    endif
!
! - Get list of components in field
!
    call romGetListComponents(fieldRefe        , fieldSupp        , nbEqua,&
                              field%equaCmpName, field%listCmpName,&
                              nbCmp            , lLagr)
!
! - Save informations
!
    field%fieldName = fieldName
    field%fieldRefe = fieldRefe
    field%fieldSupp = fieldSupp
    field%mesh      = mesh
    field%model     = model
    field%nbEqua    = nbEqua
    field%lLagr     = lLagr
    field%nbCmp     = nbCmp
!
! - Check components in field
!
    if (l_chck) then
        call romFieldChck(field)
    endif
!
end subroutine
