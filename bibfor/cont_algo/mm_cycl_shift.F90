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

subroutine mm_cycl_shift(cycl_long_acti, cycl_ecod, cycl_long)
!
implicit none
!
#include "asterfort/iscode.h"
#include "asterfort/isdeco.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: cycl_long_acti
    integer, intent(inout) :: cycl_ecod
    integer, intent(inout) :: cycl_long
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Shift detection (index greater than cycling length)
!
! --------------------------------------------------------------------------------------------------
!
! In  cycl_long_acti   : length of cycling to detect
! IO  cycl_ecod        : coded integer for cycling
! IO  cycl_long        : cycling length
!
! --------------------------------------------------------------------------------------------------
!
    integer :: statut(30)
    integer :: cycl_index
    integer :: cycl_ecodi(1)
!
! --------------------------------------------------------------------------------------------------
!
    cycl_ecodi(1) = cycl_ecod
    call isdeco(cycl_ecodi(1), statut, 30)
    do cycl_index = 1, cycl_long_acti-1
        statut(cycl_index) = statut(cycl_index+1)
    end do
    call iscode(statut, cycl_ecodi(1), 30)
    cycl_long = cycl_long_acti - 1
    cycl_ecod = cycl_ecodi(1)

end subroutine
