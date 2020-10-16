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
subroutine romAlgoNLMecaResidual(v_cnequi, ds_algorom, l_cine, v_ccid, resi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/rsexch.h"
#include "asterfort/assert.h"
#include "blas/ddot.h"
!
real(kind=8), pointer :: v_cnequi(:)
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
aster_logical, intent(in) :: l_cine
integer, pointer :: v_ccid(:)
real(kind=8), intent(out) :: resi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem MECHANICS
!
! Evaluate residuals in applying HYPER-REDUCTION
!
! --------------------------------------------------------------------------------------------------
!
! Ptr v_cnequi           : pointer to equilibre forces vector
! In  ds_algorom       : datastructure for ROM parameters
! In  l_cine           . .true. if AFFE_CHAR_CINE
! Ptr v_ccid           : pointer to CCID object (AFFE_CHAR_CINE)
! Out resi             : value for residual
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_hrom
    character(len=8) :: resultName
    character(len=19) :: resultField
    character(len=24) :: fieldName
    integer :: iEqua, nbEqua, nbMode, iMode, iret
    real(kind=8) :: term
    real(kind=8), pointer :: resultVale(:)=> null()
    real(kind=8), pointer :: v_resi(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resi = 0.d0
!
! - Get parameters
!
    l_hrom     = ds_algorom%l_hrom
    resultName = ds_algorom%ds_empi%resultName
    nbEqua     = ds_algorom%ds_empi%mode%nbEqua
    nbMode     = ds_algorom%ds_empi%nbMode
    fieldName  = ds_algorom%ds_empi%mode%fieldName
    ASSERT(ds_algorom%ds_empi%mode%fieldSupp .eq. 'NOEU')
!
! - Compute equilibrium residual
!
    AS_ALLOCATE(vr=v_resi, size=nbEqua)
    do iEqua = 1, nbEqua
        if (l_cine) then
            if (v_ccid(iEqua) .ne. 1) then
                v_resi(iEqua) = v_cnequi(iEqua)
            endif
        else
            v_resi(iEqua) = v_cnequi(iEqua)
        endif
    enddo

!
! - Truncation of residual
!
    if (l_hrom) then
        do iEqua = 1, nbEqua
            if (ds_algorom%v_equa_int(iEqua) .eq. 1) then
                v_resi(iEqua) = 0.d0
            endif
        enddo
    endif
!
! - Compute norm
!
    do iMode = 1, nbMode
        call rsexch(' ', resultName, fieldName, iMode, resultField, iret)
        call jeveuo(resultField(1:19)//'.VALE', 'E', vr = resultVale)
        term = ddot(nbEqua, resultVale, 1, v_resi, 1)
        resi = max (resi, abs(term))
    enddo
!
! - Cleaning
!    
    AS_DEALLOCATE(vr=v_resi)
!
end subroutine
