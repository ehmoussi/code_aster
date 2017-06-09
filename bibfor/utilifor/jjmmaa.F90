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

subroutine jjmmaa(ct, aut)
    implicit none
!
#include "asterc/kloklo.h"
#include "asterfort/codent.h"
    character(len=12) :: aut
    character(len=4) :: ct(3)
    integer :: t(9)
!
!  ----------- FIN DECLARATIONS _____________
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    aut='INTERF_ST/TF'
!
!
    call kloklo(t)
    t(1)=t(2)
    t(2)=t(3)
    t(3)=t(4)
    if (t(1) .le. 9) then
        ct(1)='0   '
        call codent(t(1), 'G', ct(1)(2:2))
    else
        ct(1)='    '
        call codent(t(1), 'G', ct(1)(1:2))
    endif
    if (t(2) .le. 9) then
        ct(2)='0   '
        call codent(t(2), 'G', ct(2)(2:2))
    else
        ct(2)='    '
        call codent(t(2), 'G', ct(2)(1:2))
    endif
    ct(3)='    '
    call codent(t(3), 'G', ct(3))
!
end subroutine
