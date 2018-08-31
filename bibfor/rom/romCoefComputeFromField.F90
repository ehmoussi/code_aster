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
subroutine romCoefComputeFromField(ds_empi, v_field, v_vect)
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
type(ROM_DS_Empi), intent(in) :: ds_empi
real(kind=8), pointer :: v_field(:)
real(kind=8), pointer :: v_vect(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Compute reduced coordinates from field
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes (on RID)
! In  v_field          : pointer to field to project on empiric base
! Out v_vect           : pointer to reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_equa, nb_mode
    integer(kind=4) :: info
    real(kind=8), pointer    :: v_matr_phi(:) => null()
    real(kind=8), pointer    :: v_matr(:) => null()
    integer(kind=4), pointer :: IPIV(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_mode = ds_empi%nb_mode
    nb_equa = ds_empi%nb_equa
!
! - Allocate objects
!
    AS_ALLOCATE(vr = v_matr, size = nb_mode*nb_mode)
    AS_ALLOCATE(vi4 = IPIV, size = nb_mode)
!
! - Create [PHI] matrix for primal base
!
    call romBaseCreateMatrix(ds_empi, v_matr_phi)
!
! - COmpute reduced coefficients
!
    call dgemm('T', 'N', nb_mode, 1, nb_equa, 1.d0,&
               v_matr_phi, nb_equa, v_field, nb_equa, 0.d0, v_vect, nb_mode)
    call dgemm('T', 'N', nb_mode, nb_mode, nb_equa, 1.d0,&
               v_matr_phi, nb_equa, v_matr_phi, nb_equa, 0.d0, v_matr, nb_mode)
    call dgesv(nb_mode, 1, v_matr, nb_mode, IPIV, v_vect, nb_mode, info)
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
