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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_main_podincr(l_reuse, ds_para_pod, field_iden, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/dbr_calcpod_q.h"
#include "asterfort/dbr_pod_incr.h"
#include "asterfort/dbr_calcpod_save.h"
#include "asterfort/as_deallocate.h"
!
aster_logical, intent(in) :: l_reuse
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
character(len=24), intent(in) :: field_iden
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute empiric modes - Incremental POD method
!
! --------------------------------------------------------------------------------------------------
!
! In  l_reuse          : .true. if reuse
! In  field_iden       : identificator of field (name in results datastructure)
! In  ds_para_pod      : datastructure for parameters (POD)
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), pointer :: q(:) => null()
    real(kind=8), pointer :: v(:) => null()
    real(kind=8), pointer :: s(:) => null()
    integer :: nb_mode, nb_snap_redu, nb_mode_maxi
!
! --------------------------------------------------------------------------------------------------
!
    nb_mode_maxi = ds_para_pod%nb_mode_maxi
!
! - Create snapshots matrix Q
!    
    call dbr_calcpod_q(ds_empi, ds_para_pod%ds_snap, q)
!
! - Incremental POD method
!
    call dbr_pod_incr(l_reuse, nb_mode_maxi, ds_empi, ds_para_pod,&
                      q, s, v, nb_mode, nb_snap_redu)
!
! - Save empiric base
!
    call dbr_calcpod_save(ds_empi, nb_mode, nb_snap_redu, field_iden, s, v)
!
! - Cleaning
!
    AS_DEALLOCATE(vr = q)
    AS_DEALLOCATE(vr = v)
    AS_DEALLOCATE(vr = s)
!
end subroutine
