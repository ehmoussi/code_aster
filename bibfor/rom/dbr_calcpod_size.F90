! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine dbr_calcpod_size(ds_empi, ds_snap,&
                            m      , n )
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
type(ROM_DS_Snap), intent(in) :: ds_snap
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
! In  ds_empi          : datastructure for empiric modes
! In  ds_snap          : datastructure for snapshot selection
! Out m                : first dimension of snapshot matrix
! Out m                : second dimension of snapshot matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_equa, nb_slice, nb_snap
    character(len=8)  :: base_type
!
! --------------------------------------------------------------------------------------------------
!
    nb_snap      = ds_snap%nb_snap
    base_type    = ds_empi%base_type
    nb_slice     = ds_empi%ds_lineic%nb_slice
    nb_equa      = ds_empi%nb_equa
!
! - Prepare parameters for LAPACK
!
    if (base_type .eq. 'LINEIQUE') then
        m      = nb_equa/nb_slice
        n      = nb_slice*nb_snap        
    else
        m      = nb_equa
        n      = nb_snap
    endif
!
end subroutine
