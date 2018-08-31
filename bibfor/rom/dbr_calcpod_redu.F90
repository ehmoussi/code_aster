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

subroutine dbr_calcpod_redu(nb_snap, m, q, v, nb_mode, v_gamma)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "blas/dgemm.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer              , intent(in)  :: nb_snap
    integer              , intent(in)  :: m
    real(kind=8), pointer  :: q(:)
    real(kind=8), pointer  :: v(:)
    integer              , intent(in)  :: nb_mode
    real(kind=8), pointer :: v_gamma(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Compute reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_snap          : number of snapshots for compute reduced coordinates
! In  q                : pointer to snapshots matrix
! In  m                : number of lines
! In  v                : singular vectors 
! In  nb_mode          : number of modes
! Out v_gamma          : pointer to reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8), pointer :: v_pod(:) => null()
    integer :: ieq, i_mode
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM7_12')
    endif
!
! - Get parameters
!
    ASSERT(nb_snap .gt. 0)
!
! - Compute reduced coordinates
!
    AS_ALLOCATE(vr = v_pod  , size = m*nb_mode)
    AS_ALLOCATE(vr = v_gamma, size = nb_mode*nb_snap)
    do i_mode = 1, nb_mode
        do ieq = 1, m
            v_pod(ieq+m*(i_mode-1)) = v(ieq+m*(i_mode-1))
        enddo
    enddo
    call dgemm('T', 'N', nb_mode, nb_snap, m, 1.d0, v_pod, m, q, m, 0.d0, v_gamma, nb_mode)
    AS_DEALLOCATE(vr = v_pod)
!
end subroutine
