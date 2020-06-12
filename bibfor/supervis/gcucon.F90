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

subroutine gcucon(result_name, type_name, ier)
    implicit none
    character(len=*), intent(in) :: result_name
    character(len=*), intent(in) :: type_name
    integer, intent(out) :: ier

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"

! Tell if a result name 'result_name' of type 'type_name' already exists.
!
! IN    result_name (K8): Name of the result to be checked.
! IN    type_name (K16): Name of the result type.
! OUT   ier (integer): 0 if the result does not exist, 1 otherwise.
!
    character(len=19) :: result
!
    result = result_name
!
    select case (type_name)
    case ("EVOL_NOLI", "EVOL_THER", "DYNA_HARMO", "MODE_EMPI", "MODE_MECA", "MODE_MECA_C")
        call jeexin(result//".DESC", ier)
    case ("MODE_FLAMB", "HARM_GENE", "ACOU_HARMO")
        call jeexin(result//".DESC", ier)
    case default
        ASSERT(ASTER_FALSE)
    end select
end subroutine
