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
subroutine dbr_main_pod(paraPod, field_iden, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dbr_calcpod_q.h"
#include "asterfort/dbr_calcpod_redu.h"
#include "asterfort/dbr_calcpod_save.h"
#include "asterfort/dbr_calcpod_sele.h"
#include "asterfort/dbr_calcpod_size.h"
#include "asterfort/dbr_calcpod_svd.h"
#include "asterfort/romTableSave.h"
!
character(len=24), intent(in) :: field_iden
type(ROM_DS_ParaDBR_POD), intent(in) :: paraPod
type(ROM_DS_Empi), intent(inout) :: base
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
! In  paraPod          : datastructure for parameters (POD)
! IO  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_sing, nb_mode, nb_snap_redu, i_snap, nb_mode_maxi, m, n
    real(kind=8), pointer :: q(:) => null()
    real(kind=8), pointer :: v(:) => null()
    real(kind=8), pointer :: s(:) => null() 
    real(kind=8), pointer :: v_gamma(:) => null()
    real(kind=8) :: tole_svd
!
! --------------------------------------------------------------------------------------------------
!
    tole_svd     = paraPod%tole_svd
    nb_snap_redu = paraPod%ds_snap%nb_snap
    nb_mode_maxi = paraPod%nb_mode_maxi
!
! - Get size of snapshots matrix
!
    call dbr_calcpod_size(base, paraPod%ds_snap,&
                          m   , n )
!
! - Create snapshots matrix Q
!    
    call dbr_calcpod_q(base, paraPod%ds_snap, m, n, q)
!
! - Compute empiric modes by SVD
!
    call dbr_calcpod_svd(m, n, q, s, v, nb_sing)
!
! - Select empiric modes
!
    call dbr_calcpod_sele(nb_mode_maxi, tole_svd, s, nb_sing, nb_mode)
!
! - Save empiric modes
! 
    call dbr_calcpod_save(base, nb_mode, nb_snap_redu, field_iden, s, v)
!
! - Compute reduced coordinates
!
    call dbr_calcpod_redu(nb_snap_redu, m, q, v, nb_mode, v_gamma)
!
! - Save the reduced coordinates in a table
!
    do i_snap = 1, nb_snap_redu
        call romTableSave(paraPod%tablReduCoor%tablResu, nb_mode, v_gamma   ,&
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
