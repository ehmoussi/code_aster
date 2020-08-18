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
subroutine romBaseSave(base     , nbMode   , nbSnap,&
                       baseValeR, baseSing_, baseNumeSlice_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romModeSave.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
type(ROM_DS_Empi), intent(in) :: base
integer, intent(in) :: nbMode, nbSnap
real(kind=8), pointer :: baseValeR(:)
real(kind=8), optional, pointer :: baseSing_(:)
integer, optional, pointer      :: baseNumeSlice_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Base management
!
! Save base
!
! --------------------------------------------------------------------------------------------------
!
! In  base            : base
! In  nbMode          : number of modes in base
! In  nbSnap          : number of snapshots used to construct base
! Ptr baseValeR       : pointer to the values of all modes in base
! Ptr baseSing        : pointer to the singular values of all modes in base
! Ptr baseNumeSlice   : pointer to the index of all slices in base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iMode, iEqua, numeMode
    integer :: nbEqua, numeSlice
    real(kind=8) :: modeSing
    character(len=8)  :: resultName
    type(ROM_DS_Field) :: mode
    real(kind=8), pointer :: modeValeR(:) => null()
    character(len=24) :: fieldName
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM12_2', si = nbMode)
    endif
!
! - Get parameters
!
    resultName = base%resultName
    mode       = base%mode
    nbEqua     = mode%nbEqua
    fieldName  = mode%fieldName
    AS_ALLOCATE(vr = modeValeR, size = nbEqua)
!
! - Save modes
!
    do iMode = 1, nbMode
        numeMode  = iMode
        numeSlice = 0
        modeSing  = 0
        if (present(baseNumeSlice_)) then
            numeSlice = baseNumeSlice_(iMode)
        endif
        if (present(baseSing_)) then
            modeSing  = baseSing_(iMode)
        endif
        do iEqua = 1, nbEqua
            modeValeR(iEqua) = baseValeR(nbEqua*(iMode-1)+iEqua)
        end do
        call romModeSave(resultName, numeMode ,&
                         fieldName , mode     ,&
                         modeValeR_ = modeValeR,&
                         modeSing_  = modeSing ,&
                         numeSlice_ = numeSlice,&
                         nbSnap_    = nbSnap)
    end do
!
! - Clean
!
    AS_DEALLOCATE(vr = modeValeR)
!
end subroutine
