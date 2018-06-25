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

subroutine dbr_calcpod_svd2(p, incr_end, g, s, b, nb_sing)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "blas/dgesvd.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: p
    integer, intent(in) :: incr_end
    real(kind=8), pointer :: g(:)
    real(kind=8), pointer :: b(:)
    real(kind=8), pointer :: s(:)
    integer, intent(out) :: nb_sing
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Compute empiric modes by SVD
!
! --------------------------------------------------------------------------------------------------
!
! In  incr_end         : total number of snapshots
! In  p                : number of snapshots computed (<= total number of snaps)
! In  g                : pointer to [g] matrix
! Out s                : singular values 
! Out b                : singular vectors
! Out nb_sing          : total number of singular values
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: lda, lwork
    real(kind=8), pointer :: w(:)    => null()
    real(kind=8), pointer :: work(:) => null()
    integer(kind=4) :: info
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_7')
    endif
!
! - Prepare parameters for LAPACK
!
    lda     = max(1, p)
    nb_sing = min(p, incr_end)
    lwork   = max(1,3*nb_sing+lda,5*nb_sing)
    AS_ALLOCATE(vr = b, size = p*nb_sing)
    AS_ALLOCATE(vr = s, size = nb_sing)
    AS_ALLOCATE(vr = work, size = lwork)
!
! - Compute SVD: Q = V S Wt
!
    call dgesvd('S', 'N', p, incr_end, g,&
                lda, s, b, p, w,&
                1, work, lwork, info)
    if (info .ne. 0) then
        call utmess('F', 'ROM5_8')
    endif
    if (niv .ge. 2) then
        call utmess('I', 'ROM7_10', si = 8*lwork)
    endif
!
! - Clean
!
    AS_DEALLOCATE(vr = work)
!
end subroutine
