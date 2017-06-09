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

subroutine modthm(modint)
    implicit none
#include "asterf_types.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
    character(len=3), intent(out) :: modint
! --- determination du mode d'integration : CLA/RED/LUM
!     pour le type_element courant.
! =====================================================================
    aster_logical :: lprincip
    integer :: iret
    character(len=1) :: d1, d2
    character(len=3) :: mint
! =====================================================================
!
!   -- l'element est-il principal ?
    call teattr('S', 'DIM_TOPO_MODELI', d1, iret)
    call teattr('S', 'DIM_TOPO_MAILLE', d2, iret)
    lprincip=(d1.eq.d2)
!
    modint='CLA'
    if (lprincip) then
        call teattr('C', 'INTTHM', mint, iret)
        if (iret .eq. 0) modint=mint
    endif
! =====================================================================
end subroutine
