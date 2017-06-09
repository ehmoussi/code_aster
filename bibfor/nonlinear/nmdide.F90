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

subroutine nmdide(l_reuse, result, nume_last, inst_last)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/rs_getlast.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: result
    aster_logical, intent(in) :: l_reuse
    integer, intent(out) :: nume_last
    real(kind=8), intent(out) :: inst_last
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm - Initial state management
!
! Last time in result datastructure if initial state given
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of result datastructure (EVOL_NOLI)
! In  l_reuse          : .true. if reuse results datastructure
! Out nume_last        : last index stored in results datastructure
!                        0 if not reuse
! Out inst_last        : last time stored in results datastructure
!                        r8vide if not reuse
!
! --------------------------------------------------------------------------------------------------
!
    nume_last = 0
    inst_last = r8vide()
!
    if (l_reuse) then
        call rs_getlast(result, nume_last, inst_last = inst_last)
    endif
!
end subroutine
