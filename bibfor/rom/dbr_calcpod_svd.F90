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

subroutine dbr_calcpod_svd(ds_empi, ds_snap, q, s, v, nb_sing, nb_line_svd)
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
    type(ROM_DS_Empi), intent(in) :: ds_empi
    type(ROM_DS_Snap), intent(in) :: ds_snap
    real(kind=8), pointer, intent(inout) :: q(:)
    real(kind=8), intent(out), pointer :: v(:)
    real(kind=8), intent(out), pointer :: s(:)  
    integer, intent(out) :: nb_sing
    integer, intent(out) :: nb_line_svd 
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Compute empiric modes by SVD
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! In  ds_snap          : datastructure for snapshot selection
! In  q                : pointer to [q] matrix
! Out s                : singular values 
! Out v                : singular vectors
! Out nb_line_svd      : number of lines for SVD 
! Out nb_sing          : total number of singular values
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: m, n
    integer :: nb_equa, nb_slice, nb_snap, nb_cmp
    integer :: lda, lwork
    character(len=8)  :: base_type
    real(kind=8), pointer :: w(:) => null()
    real(kind=8), pointer :: qq(:) => null()
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
! - Init
!
    nb_sing      = 0
    v            => null()
    s            => null()
!
! - Get parameters
!
    nb_snap      = ds_snap%nb_snap
    base_type    = ds_empi%base_type
    nb_slice     = ds_empi%ds_lineic%nb_slice
    nb_equa      = ds_empi%nb_equa
    nb_cmp       = ds_empi%nb_cmp
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
    nb_line_svd = m
    lda         = max(1, m)
    nb_sing     = min(m, n)
    lwork       = max(1,3*nb_sing+lda,5*nb_sing)
    AS_ALLOCATE(vr = v, size = m*nb_sing)
    AS_ALLOCATE(vr = s, size = nb_sing)
    AS_ALLOCATE(vr = work, size = lwork)
!
! - Use copy of Q matrix (because dgesvd change it ! )
!
    AS_ALLOCATE(vr = qq, size = m*n)
    qq(1:m*n) = q(1:m*n)
!
! - Compute SVD: Q = V S Wt
!
    call dgesvd('S', 'N', m, n, qq,&
                lda, s, v, m, w,&
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
    AS_DEALLOCATE(vr = qq)
    AS_DEALLOCATE(vr = work)
!
end subroutine
