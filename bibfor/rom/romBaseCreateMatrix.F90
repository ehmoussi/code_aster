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
subroutine romBaseCreateMatrix(base, matrPhi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/rsexch.h"
#include "asterfort/jeveuo.h"
!
type(ROM_DS_Empi), intent(in) :: base
real(kind=8), pointer :: matrPhi(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Base management
!
! Create [PHI] matrix from base
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
! Out matrPhi          : pointer to [PHI] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iMode, iret, iEqua
    integer :: nbEqua, nbMode, numeMode
    character(len=24) :: resultField, fieldName
    character(len=8) :: resultName
    real(kind=8), pointer :: fieldVale(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    nbMode     = base%nbMode
    resultName = base%resultName
    nbEqua     = base%mode%nbEqua
    fieldName  = base%mode%fieldName
    if (niv .ge. 2) then
        call utmess('I', 'ROM12_1', ni = 2, vali = [nbEqua, nbMode])
    endif
!
! - Create [PHI] matrix
!
    AS_ALLOCATE(vr = matrPhi, size = nbEqua*nbMode)
    do iMode = 1, nbMode
        numeMode = iMode
        call rsexch(' '     , resultName , fieldName,&
                    numeMode, resultField, iret)
        ASSERT(iret .eq. 0)
        call jeveuo(resultField(1:19)//'.VALE', 'L', vr = fieldVale)
        do iEqua = 1, nbEqua
            matrPhi(iEqua+nbEqua*(iMode-1)) = fieldVale(iEqua)
        end do
    end do
!
end subroutine
