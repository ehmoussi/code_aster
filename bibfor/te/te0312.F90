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

subroutine te0312(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
!
!  CALCUL DU CHARGEMENT DU AU SECHAGE ET A L'HYDRATATION
!.......................................................................
!
    integer :: lmater
    character(len=8) :: fami, poum
    real(kind=8) :: bendog(1),kdessi(1),alpha(1)
    integer :: icodre(2), kpg, spt
!.......................................................................
!
    call jevech('PMATERC', 'L', lmater)
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
    if (option.eq.'CHAR_MECA_HYDR_R') then
        call rcvalb(fami, kpg, spt, poum, zi(lmater),&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'B_ENDOGE', bendog, icodre, 0)
!
        if ((icodre(1).eq.0) .and. (bendog(1).ne.0.d0)) then
            call utmess('F', 'ELEMENTS_22', sk=nomte)
        else
!       -- BENDOGE ABSENT => CHARGEMENT NUL
        endif
    else if (option.eq.'CHAR_MECA_SECH_R') then
        call rcvalb(fami, kpg, spt, poum, zi(lmater),&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'K_DESSIC', kdessi, icodre, 0)
!
        if ((icodre(1).eq.0) .and. (kdessi(1).ne.0.d0)) then
            call utmess('F', 'ELEMENTS_23', sk=nomte)
        else
!       -- KDESSI ABSENT => CHARGEMENT NUL
        endif
    else if (option.eq.'CHAR_MECA_TEMP_R') then
        call rcvalb(fami, kpg, spt, poum, zi(lmater),&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'ALPHA', alpha, icodre, 0)
!
        if ((icodre(1).eq.0) .and. (alpha(1).ne.0.d0)) then
            call utmess('F', 'ELEMENTS_19', sk=nomte)
        else
!       -- ALPHA ABSENT => CHARGEMENT NUL
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
