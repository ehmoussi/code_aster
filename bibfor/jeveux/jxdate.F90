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

subroutine jxdate(idate)
    implicit none
#include "asterc/datetoi.h"
    integer :: idate
!                            31 / 01 / 90
!     ------------------------------------------------------------------
!             ROUTINE AVEC ADHERENCE SYSTEME    CRAY
!     ------------------------------------------------------------------
    integer :: ival(6)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call datetoi(ival)
    idate = 100000000 * ival(3) + 1000000 * ival(2) + 10000 * ival(1) + 100 * ival(4) + ival(5)
!
end subroutine
