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

!> Register the supervisor type name in the result itself.

!> The type name is the name of the Python class in uppercases.
!>
!> Only the datastructures created by calling an opXXXX subroutine are registered
!> by the supervisor (see E_ETAPE.Exec).

!> @param[in]  name     name of the datastructure
!> @param[in]  typeco   name of the supervisor type.

subroutine settco(name, typeco)
! person_in_charge: mathieu.courtois@edf.fr

    implicit none

#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"

!   arguments
    character(len=*), intent(in) :: name
    character(len=*), intent(in) :: typeco

    character(len=8) :: name8
    character(len=16) :: attr
    character(len=24) :: type24
    integer :: iret
    character(len=24), pointer :: vk(:) => null()

    call jemarq()

    name8 = name
    type24 = typeco
    attr = name8//'._TYPCO_'
    call jeexin(attr, iret)
    if (iret .eq. 0) then
        call wkvect(attr, 'G V K24', 1, vk24=vk)
    else
        call jeveuo(attr, 'E', vk24=vk)
    endif
    vk(1) = type24

    call jedema()

end subroutine settco
