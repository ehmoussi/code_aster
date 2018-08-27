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
subroutine dbr_calcpod_save(ds_empi, nb_mode, nb_snap_redu, field_iden, s, v)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/romBaseSave.h"
#include "asterfort/dbr_calcpod_savel.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
integer, intent(in) :: nb_mode
integer, intent(in) :: nb_snap_redu
character(len=24), intent(in) :: field_iden
real(kind=8), pointer :: v(:)
real(kind=8), pointer :: s(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Save empiric modes
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! In  nb_mode          : number of empiric modes
! In  nb_snap_redu     : number of snapshots used to construct empiric base
! In  field_iden       : identificator of field (name in results datastructure)
! In  s                : singular values
! In  v                : singular vectors
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: base_type
    integer :: nb_equa
    integer, pointer :: v_nume_slice(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_equa      = ds_empi%ds_mode%nb_equa
    base_type    = ds_empi%base_type
!
    if (base_type .eq. 'LINEIQUE') then
        call dbr_calcpod_savel(ds_empi, nb_mode, nb_snap_redu, field_iden, nb_equa, s, v)
    else
        AS_ALLOCATE(vi=v_nume_slice, size = nb_mode)
        call romBaseSave(ds_empi, nb_mode, nb_snap_redu, mode_type = 'R',&
                         field_iden    = field_iden,&
                         mode_vectr_   = v, &
                         v_mode_freq_  = s, &
                         v_nume_slice_ = v_nume_slice)
        AS_DEALLOCATE(vi = v_nume_slice)
    endif
!
end subroutine
