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
subroutine dbr_main_podincr(l_reuse, paraPod, fieldName, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dbr_calcpod_q.h"
#include "asterfort/dbr_calcpod_save.h"
#include "asterfort/dbr_calcpod_size.h"
#include "asterfort/dbr_pod_incr.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: l_reuse
type(ROM_DS_ParaDBR_POD), intent(in) :: paraPod
character(len=24), intent(in) :: fieldName
type(ROM_DS_Empi), intent(inout) :: base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute base - Incremental POD method
!
! --------------------------------------------------------------------------------------------------
!
! In  l_reuse          : .true. if reuse
! In  fieldName        : identificator of field (name in results datastructure)
! In  paraPod          : datastructure for parameters (POD)
! IO  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), pointer :: q(:) => null(), v(:) => null(), s(:) => null()
    integer :: nbMode, nbSnap, m, n
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get size of snapshots matrix
!
    call dbr_calcpod_size(base, paraPod%snap,&
                          m   , n )
!
! - Create snapshots matrix Q
!    
    call dbr_calcpod_q(base, paraPod%resultDom%resultName,paraPod%snap, m, n, q)
!
! - Incremental POD method
!
    call dbr_pod_incr(l_reuse, base  , paraPod,&
                      q, s, v, nbMode, nbSnap)
!
! - Save empiric base
!
    call dbr_calcpod_save(base, nbMode, nbSnap, fieldName, s, v)
!
! - Clean
!
    AS_DEALLOCATE(vr = q)
    AS_DEALLOCATE(vr = v)
    AS_DEALLOCATE(vr = s)
!
end subroutine
