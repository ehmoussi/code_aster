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
subroutine dbr_main_ortho(paraOrtho, baseOut)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dbr_calcpod_svd.h"
#include "asterfort/infniv.h"
#include "asterfort/romBaseCreateMatrix.h"
#include "asterfort/romBaseSave.h"
#include "asterfort/utmess.h"
#include "asterfort/vpgskp.h"
!
type(ROM_DS_ParaDBR_ORTHO), intent(in) :: paraOrtho
type(ROM_DS_Empi), intent(in) :: baseOut
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute base - For orthogonalization
!
! --------------------------------------------------------------------------------------------------
!
! In  paraOrtho        : datastructure for parameters (orthogonalization)
! In  baseOut          : output base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: lmatb, nbMode, nbEqua, nbSnap
    real(kind=8) :: alpha
    real(kind=8), pointer :: trav1(:) => null()
    real(kind=8), pointer :: trav3(:) => null()
    integer, pointer :: ddlexc(:) => null()
    real(kind=8), pointer :: matrPhi(:) => null()
    real(kind=8), pointer :: v(:) => null()
    real(kind=8), pointer :: s(:) => null()
    integer :: nbSing
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_57')
    endif
!
! - Get parameters
!
    nbMode = baseOut%nbMode
    nbEqua = baseOut%mode%nbEqua
    nbSnap = baseOut%nbSnap
    alpha  = paraOrtho%alpha
!
! - Working vectors
!
    AS_ALLOCATE(vr=trav1, size=nbEqua)
    AS_ALLOCATE(vr=trav3, size=nbMode)
    AS_ALLOCATE(vi=ddlexc, size=nbEqua)
!
! - All DOF
!
    ddlexc(1:nbEqua) = 1
!
! - Create [PHI] matrix from base
!
    call romBaseCreateMatrix(paraOrtho%ds_empi_init, matrPhi)
!
! - Compute
!
    call vpgskp(nbEqua, nbMode, matrPhi, alpha, lmatb,&
                0     , trav1 , ddlexc , trav3)
!
! - Compute base by SVD
!
    call dbr_calcpod_svd(nbMode, nbEqua, matrPhi, s, v, nbSing)
!
! - Save base
!
    call romBaseSave(baseOut, nbMode, nbSnap, matrPhi)
!
! - Cleaning
!
    AS_DEALLOCATE(vr = trav1)
    AS_DEALLOCATE(vr = trav3)
    AS_DEALLOCATE(vi = ddlexc)
    AS_DEALLOCATE(vr = matrPhi)
    AS_DEALLOCATE(vr = v)
    AS_DEALLOCATE(vr = s)
!
end subroutine
