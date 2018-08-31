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
subroutine dbr_main_pod(ds_para_pod, field_iden, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dbr_calcpod_q.h"
#include "asterfort/dbr_calcpod_svd.h"
#include "asterfort/dbr_calcpod_sele.h"
#include "asterfort/dbr_calcpod_save.h"
#include "asterfort/dbr_calcpod_redu.h"
#include "asterfort/romTableSave.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
character(len=24), intent(in) :: field_iden
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute empiric modes - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  field_iden       : identificator of field (name in results datastructure)
! In  ds_para_pod      : datastructure for parameters (POD)
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_sing, nb_mode, nb_snap_redu, nb_line_svd, i_snap, nb_mode_maxi
    real(kind=8), pointer :: q(:) => null()
    real(kind=8), pointer :: v(:) => null()
    real(kind=8), pointer :: s(:) => null() 
    real(kind=8), pointer :: v_gamma(:) => null()
    character(len=19) :: tabl_name
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    tabl_name    = ds_para_pod%tabl_name
    nb_snap_redu = ds_para_pod%ds_snap%nb_snap
    nb_mode_maxi = ds_para_pod%nb_mode_maxi
    nb_line_svd  = 0
!
! - Create snapshots matrix Q
!    
    call dbr_calcpod_q(ds_empi, ds_para_pod%ds_snap, q)
!
! - Compute empiric modes by SVD
!
    call dbr_calcpod_svd(ds_empi, ds_para_pod%ds_snap, q, s, v, nb_sing, nb_line_svd)
!
! - Select empiric modes
!
    call dbr_calcpod_sele(nb_mode_maxi, ds_para_pod%tole_svd, s, nb_sing, nb_mode)
!
! - Save empiric modes
! 
    call dbr_calcpod_save(ds_empi, nb_mode, nb_snap_redu, field_iden, s, v)
!
! - Compute reduced coordinates
!
    call dbr_calcpod_redu(nb_snap_redu, nb_line_svd, q, v, nb_mode, v_gamma)
!
! - Save the reduced coordinates in a table
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_39', ni = 2, vali = [nb_snap_redu, nb_mode])
    endif
    do i_snap = 1, nb_snap_redu
        call romTableSave(tabl_name  , nb_mode, v_gamma   ,&
                          nume_snap_ = i_snap)
    end do
!
! - Cleaning
!
    AS_DEALLOCATE(vr = q)
    AS_DEALLOCATE(vr = v)
    AS_DEALLOCATE(vr = s)
    AS_DEALLOCATE(vr = v_gamma)
!
end subroutine
