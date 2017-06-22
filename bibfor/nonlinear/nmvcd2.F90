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

subroutine nmvcd2(name_varcz, matez, exis_varc)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
!
    character(len=*), intent(in) :: name_varcz
    character(len=*), intent(in) :: matez
    aster_logical, intent(out) :: exis_varc
!
! --------------------------------------------------------------------------------------------------
!
! Command variables
!
! Is command variable exists ?
!
! --------------------------------------------------------------------------------------------------
!
! In  name_varc : name of command variable
! In  mate      : name of material field
! Out exis_varc : .true. if this command variable has been affected
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nmax,  i, iret
    character(len=8) :: mate
    character(len=8) :: name_varc
    character(len=8), pointer :: cvrcvarc(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    mate      = matez
    name_varc = name_varcz
    exis_varc = .false.
!
    call jeexin(mate// '.CVRCVARC', iret)
    if (iret .ne. 0) then
        call jelira(mate// '.CVRCVARC', 'LONMAX', ival=nmax)
        call jeveuo(mate// '.CVRCVARC', 'L'     , vk8 =cvrcvarc)
        do i = 1, nmax
            if (cvrcvarc(i) .eq. name_varc) then
                exis_varc=.true.
                goto 2
            endif
        end do
 2      continue
    endif
!
    call jedema()
end subroutine
