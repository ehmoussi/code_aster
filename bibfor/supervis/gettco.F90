! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

!> Returns the supervisor type name of the result.

!> The type name is the name of the Python class in uppercases.
!>
!> It returns ' ' if the datastructure has not been registered.

!> @param[in]  name     Name of the datastructure
!> @param[out] typeco   Name of the supervisor type.
!> @param[in]  errstop  Interrupt the execution if the type is unknown (optional).

subroutine gettco(name, typeco, errstop)
! person_in_charge: mathieu.courtois@edf.fr

    implicit none

#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/gettc2.h"
#include "asterfort/assert.h"

!   arguments
    character(len=*), intent(in) :: name
    character(len=*), intent(out) :: typeco
    aster_logical, intent(in), optional :: errstop

    aster_logical :: fail_on_error
    fail_on_error = ASTER_TRUE
    if (present(errstop)) then
        fail_on_error = errstop
    endif

    ASSERT(name .ne. ' ')
    call gettc2(name, typeco)
    ASSERT(.not. fail_on_error .or. typeco .ne. ' ')

end subroutine gettco
