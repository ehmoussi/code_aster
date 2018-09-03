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
subroutine dbr_calcpod_savel(ds_empi, nb_mode, nb_snap_redu, field_iden, nb_equa, s, v)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/romBaseSave.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
integer, intent(in) :: nb_mode
integer, intent(in) :: nb_snap_redu
character(len=24), intent(in) :: field_iden
integer, intent(in) :: nb_equa
real(kind=8), pointer :: v(:)
real(kind=8), pointer :: s(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Save empiric modes for lineic model
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! In  nb_mode          : number of empiric modes
! In  nb_snap_redu     : number of snapshots used to construct empiric base
! In  field_iden       : identificator of field (name in results datastructure)
! In  nb_equa          : number of equations (length of empiric mode)
! In  s                : singular values
! In  v                : singular vectors
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_slice, i_mode, i_node, i_cmp, i_2d, i_equa
    integer :: nb_slice, n_2d, nb_cmp
    real(kind=8), pointer :: v_lin(:) => null()
    real(kind=8), pointer :: s_lin(:) => null()
    integer, pointer :: v_nume_slice(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_cmp    = ds_empi%ds_lineic%nb_cmp
    nb_slice  = ds_empi%ds_lineic%nb_slice
!
! - Create working objects
!
    AS_ALLOCATE(vr=v_lin, size = nb_equa*nb_mode*nb_slice)
    AS_ALLOCATE(vr=s_lin, size = nb_mode*nb_slice)
    AS_ALLOCATE(vi=v_nume_slice, size = nb_mode*nb_slice)
!
! - Create index of slices
!
    do i_slice = 1, nb_slice
        do i_mode = 1, nb_mode
            s_lin(i_mode + nb_mode*(i_slice - 1)) = s(i_mode)
            v_nume_slice(i_mode + nb_mode*(i_slice - 1)) = i_slice
        enddo
    enddo
!
! - Create modes to save
!
    do i_equa = 1, nb_equa
        i_node  = (i_equa - 1)/nb_cmp + 1
        i_cmp   = i_equa - (i_node - 1)*nb_cmp
        i_slice = ds_empi%ds_lineic%v_nume_pl(i_node)
        n_2d    = ds_empi%ds_lineic%v_nume_sf(i_node)
        i_2d    = (n_2d - 1)*nb_cmp + i_cmp
        do i_mode = 1, nb_mode
            v_lin(i_equa + nb_equa*(i_mode - 1 + nb_mode*(i_slice - 1))) =&
                v(i_2d + nb_equa/nb_slice*(i_mode - 1))
        enddo
    enddo
!
! - Save modes
!
    call romBaseSave(ds_empi, nb_mode*nb_slice, nb_snap_redu, mode_type = 'R',&
                     field_iden    = field_iden,&
                     mode_vectr_   = v_lin, &
                     v_mode_freq_  = s_lin, &
                     v_nume_slice_ = v_nume_slice)
!
! - Cleaning
!
    AS_DEALLOCATE(vr = v_lin)
    AS_DEALLOCATE(vr = s_lin)
    AS_DEALLOCATE(vi = v_nume_slice)
!
end subroutine
