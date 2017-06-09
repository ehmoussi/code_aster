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

subroutine jedup1(o1z, base, o2z)
    implicit none
#include "asterfort/jedupo.h"
#include "asterfort/jeexin.h"
    character(len=*), intent(in) :: o1z, base, o2z
! ----------------------------------------------------------------------
!     RECOPIE L'OBJET JEVEUX "O1" SUR LA BASE "BASE" SOUS LE NOM "O2"
! ----------------------------------------------------------------------
    integer :: iret
    character(len=24) :: o1, o2
!
! DEB ------------------------------------------------------------------
    o1=o1z
    o2=o2z
    call jeexin(o1, iret)
    if (iret .gt. 0) call jedupo(o1, base, o2, .false._1)
end subroutine
