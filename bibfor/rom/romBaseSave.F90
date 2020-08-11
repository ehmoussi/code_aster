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
subroutine romBaseSave(base       , nbMode     , nbSnap,&
                       mode_type  , fieldIden  ,&
                       mode_vectr_, mode_vectc_,&
                       v_modeSing_, v_numeSlice_)
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
character(len=1), intent(in) :: mode_type
character(len=24), intent(in) :: fieldIden
real(kind=8), optional, pointer :: mode_vectr_(:)
complex(kind=8), optional, pointer :: mode_vectc_(:)
real(kind=8), optional, pointer :: v_modeSing_(:)
integer, optional, pointer      :: v_numeSlice_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save base
!
! --------------------------------------------------------------------------------------------------
!
! In  base            : datastructure for base
! In  nbMode          : number of modes in base
! In  nbSnap          : number of snapshots used to construct base
! In  mode_type       : type of mode (real or complex, 'R' ou 'C')
! In  fieldIden       : identificator of modes (name in results datastructure)
! Ptr mode_vectr      : pointer to the values of modes (real)
! Ptr mode_vectc      : pointer to the values of modes (complex)
! Ptr v_modeSing      : pointer to the singular values of modes
! Ptr v_numeSlice     : pointer to the index of slices (for lineic bases)
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
    complex(kind=8), pointer :: modeValeC(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_2', si = nbMode)
    endif
!
! - Get parameters
!
    resultName = base%base
    mode       = base%ds_mode
    nbEqua     = mode%nbEqua
    AS_ALLOCATE(vr = modeValeR, size = nbEqua)
    AS_ALLOCATE(vc = modeValeC, size = nbEqua)
!
! - Save modes
!
    do iMode = 1, nbMode
        numeMode  = iMode
        numeSlice = 0
        modeSing  = 0
        if (present(v_numeSlice_)) then
            numeSlice = v_numeSlice_(iMode)
        endif
        if (present(v_modeSing_)) then
            modeSing  = v_modeSing_(iMode)
        endif
        if (mode_type .eq. 'R') then
            do iEqua = 1, nbEqua
                modeValeR(iEqua) = mode_vectr_(nbEqua*(iMode-1)+iEqua)
            end do
            call romModeSave(resultName, numeMode ,&
                             fieldIden , mode     ,&
                             modeValeR_ = modeValeR,&
                             modeSing_  = modeSing ,&
                             numeSlice_ = numeSlice,&
                             nbSnap_    = nbSnap)
        elseif (mode_type .eq. 'C') then
            do iEqua = 1, nbEqua
                modeValeC(iEqua) = mode_vectc_(nbEqua*(iMode-1)+iEqua)
            end do
            call romModeSave(resultName, numeMode ,&
                             fieldIden , mode     ,&
                             modeValeC_ = modeValeC,&
                             modeSing_  = modeSing ,&
                             numeSlice_ = numeSlice,&
                             nbSnap_    = nbSnap)
        else
            ASSERT(ASTER_FALSE)
        endif
    end do
!
! - Clean
!
    AS_DEALLOCATE(vr = modeValeR)
    AS_DEALLOCATE(vc = modeValeC)
!
end subroutine
