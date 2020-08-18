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
subroutine romFieldBuildMatrPhiTruncate(fieldBuild)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_FieldBuild), intent(inout) :: fieldBuild
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field build
!
! Truncate [PHI] matrix
!
! --------------------------------------------------------------------------------------------------
!
! IO  fieldBuild       : field to reconstruct
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_Empi) :: base
    integer :: nbMode, nbEqua, nbEquaRID
    integer :: iMode, iEqua, numeEqua
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    base      = fieldBuild%base
    nbMode    = base%nbMode
    nbEqua    = base%mode%nbEqua
    nbEquaRID = fieldBuild%nbEquaRID
!
! - Debug
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM17_3', ni = 4,&
                                    vali = [nbMode, nbEqua, nbMode, nbEquaRID])
    endif
!
! - Allocate object
!
    AS_ALLOCATE(vr = fieldBuild%matrPhiRID, size = nbEquaRID*nbMode)
!
! - Construct object
!
    do iMode = 1, nbMode
        do iEqua = 1, nbEqua
            numeEqua = fieldBuild%equaRIDTotal(iEqua)
            if (numeEqua .ne. 0) then
                fieldBuild%matrPhiRID(numeEqua+nbEquaRID*(iMode-1)) = &
                  fieldBuild%matrPhi(iEqua+nbEqua*(iMode-1))
            endif 
        end do
    end do
!
end subroutine
