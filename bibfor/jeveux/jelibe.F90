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

subroutine jelibe(nomlu)
    implicit none
#include "asterfort/jjlide.h"
#include "asterfort/jjvern.h"
#include "asterfort/utmess.h"
    character(len=*), intent(in) :: nomlu
!     ==================================================================
    character(len=6) :: pgma
    common /kappje/  pgma
!     ==================================================================
    character(len=32) :: noml32
    integer :: icre, iret
!     ==================================================================
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    pgma = 'JELIBE'
    if (len(nomlu) .le. 0) then
        call utmess('F', 'JEVEUX1_08', sk=nomlu)
    endif
    noml32 = nomlu(1:min(32,len(nomlu)))
!
    icre = 0
    call jjvern(noml32, icre, iret)
!
    if (iret .eq. 0) then
        call utmess('F', 'JEVEUX_26', sk=noml32(1:24))
    else
        call jjlide('JELIBE', noml32, iret)
    endif
end subroutine
