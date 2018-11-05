! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine deprecated_keyw(keyw)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: keyw
!
! --------------------------------------------------------------------------------------------------
!
! DEPRECATED FEATURES
!
! Warning for deprecated keywords
!
! --------------------------------------------------------------------------------------------------
!
! In  keyw : keywords
!
! --------------------------------------------------------------------------------------------------
!
    integer :: vali
    character(len=80) :: valk
!
! --------------------------------------------------------------------------------------------------
!
    if (keyw .eq. 'TITRE') then
        vali = 14
        valk = "mot-clef TITRE"
    else
        goto 999
    endif
!
    call utmess('A', 'SUPERVIS_9', sk = valk, si = vali)
!
999 continue
!
end subroutine
