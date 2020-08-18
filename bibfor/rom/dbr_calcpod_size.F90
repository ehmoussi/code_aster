! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_calcpod_size(base, snap, m, n)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
!
type(ROM_DS_Empi), intent(in) :: base
type(ROM_DS_Snap), intent(in) :: snap
integer, intent(out) :: m, n
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Get size of snapshots matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
! In  snap             : snapshot selection
! Out m                : first dimension of snapshot matrix
! Out m                : second dimension of snapshot matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbEqua, nbSlice, nbSnap
    character(len=8)  :: baseType
!
! --------------------------------------------------------------------------------------------------
!
    nbSnap   = snap%nbSnap
    baseType = base%baseType
    nbSlice  = base%lineicNume%nbSlice
    nbEqua   = base%mode%nbEqua
!
! - Prepare parameters for LAPACK
!
    if (baseType .eq. 'LINEIQUE') then
        m = nbEqua/nbSlice
        n = nbSlice*nbSnap
    else
        m = nbEqua
        n = nbSnap
    endif
!
end subroutine
