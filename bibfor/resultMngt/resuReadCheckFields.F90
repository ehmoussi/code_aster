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
subroutine resuReadCheckFields(resultName, resultType, fieldNb, fieldList)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
#include "asterfort/jenonu.h"
!
character(len=8), intent(in) :: resultName
character(len=16), intent(in) :: resultType
integer, intent(in) :: fieldNb
character(len=16), intent(in) :: fieldList(100)
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Check if fields are allowed for the result
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  resultType       : type of results datastructure (EVOL_NOLI, EVOL_THER, )
! In  fieldNb          : number of fields to read
! In  fieldList        : list of fields to read
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iField, iexi
    character(len=16) :: fieldType
    character(len=19) :: resu19
!
! --------------------------------------------------------------------------------------------------
!
    resu19 = resultName
    do iField = 1, fieldNb
        fieldType = fieldList(iField)
        call jenonu(jexnom(resu19//'.DESC', fieldType), iexi)
        if (iexi .eq. 0) then
            call utmess('F', 'RESULT2_24', nk=2, valk=[resultType, fieldType])
        endif
    end do
!
end subroutine
