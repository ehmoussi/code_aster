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
subroutine romCoefComputeFromField(base, v_field, v_vect)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/jeveuo.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/romBaseCreateMatrix.h"
#include "blas/dgemm.h"
#include "blas/dgesv.h"
!
type(ROM_DS_Empi), intent(in) :: base
real(kind=8), pointer :: v_field(:), v_vect(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Compute reduced coordinates from field
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base (on RID)
! Ptr v_field          : pointer to field to project on empiric base
! Ptr v_vect           : pointer to reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbEqua, nbMode
    integer(kind=4) :: info
    real(kind=8), pointer    :: v_matr_phi(:) => null()
    real(kind=8), pointer    :: v_matr(:) => null()
    integer(kind=4), pointer :: IPIV(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nbMode = base%nbMode
    nbEqua = base%mode%nbEqua
!
! - Allocate objects
!
    AS_ALLOCATE(vr = v_matr, size = nbMode*nbMode)
    AS_ALLOCATE(vi4 = IPIV, size = nbMode)
!
! - Create [PHI] matrix for primal base
!
    call romBaseCreateMatrix(base, v_matr_phi)
!
! - COmpute reduced coefficients
!
    call dgemm('T', 'N', nbMode, 1, nbEqua, 1.d0,&
               v_matr_phi, nbEqua, v_field, nbEqua, 0.d0, v_vect, nbMode)
    call dgemm('T', 'N', nbMode, nbMode, nbEqua, 1.d0,&
               v_matr_phi, nbEqua, v_matr_phi, nbEqua, 0.d0, v_matr, nbMode)
    call dgesv(nbMode, 1, v_matr, nbMode, IPIV, v_vect, nbMode, info)
    if (info .ne. 0) then
        call utmess('F', 'ROM6_32')
    endif
!
! - Clean
!
    AS_DEALLOCATE(vr = v_matr)
    AS_DEALLOCATE(vr = v_matr_phi)
    AS_DEALLOCATE(vi4 = IPIV)
!
end subroutine
