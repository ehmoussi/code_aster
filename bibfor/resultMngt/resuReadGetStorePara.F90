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
subroutine resuReadGetStorePara(resultName, storePara)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/rsexpa.h"
#include "asterfort/assert.h"
!
character(len=8), intent(in) :: resultName
character(len=4), intent(out) :: storePara
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Get parameter to access results (INST or FREQ)
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! Out storePara        : name of parameter to access results (INST or FREQ)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
!
! --------------------------------------------------------------------------------------------------
!
    storePara = ' '
    call rsexpa(resultName, 0, 'INST', iret)
    if (iret .gt. 0) then
        storePara = 'INST'
    else
        call rsexpa(resultName, 0, 'FREQ', iret)
        if (iret .gt. 0) then
            storePara = 'FREQ'
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
end subroutine
