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

subroutine ststat(istat)
! person_in_charge: mathieu.courtois at edf.fr
!
!
    use parameters_module, only : ST_OK
    implicit none
#include "asterf_debug.h"
!     ARGUMENT IN
    integer :: istat
!-----------------------------------------------------------------------
!     FONCTION "SeT STATus" : ACTIVE LE DRAPEAU D'ETAT ISTAT.
!
!     LA VALEUR DU STATUT GLOBAL IGLBST EST STOCKE DANS LE COMMON CGLBST
!-----------------------------------------------------------------------
    integer :: iglbst
    common  / cglbst / iglbst
!
    if (istat .eq. ST_OK) then
        iglbst = ST_OK
    else
        iglbst = ior(istat, iglbst)
    endif
    DEBUG_MPI('set status: istat/iglbst', istat, iglbst)
end subroutine
