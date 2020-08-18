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
subroutine romMultiParaModeSave(multPara, base    ,&
                                numeMode, modeName)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "blas/zdotc.h"
#include "blas/ddot.h"
#include "asterfort/jeveuo.h"
#include "asterfort/romModeSave.h"
!
type(ROM_DS_MultiPara), intent(in) :: multPara
type(ROM_DS_Empi), intent(inout) :: base
integer, intent(in) :: numeMode
character(len=19), intent(in) :: modeName
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save mode
!
! --------------------------------------------------------------------------------------------------
!
! In  multPara        : datastructure for multiparametric problems
! IO  base            : datastructure for base
! In  numeMode        : index of mode
! In  modeName        : name of JEVEUX object for mode
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8) :: normc
    real(kind=8) :: normr
    integer :: nbEqua
    character(len=24) :: fieldName
    character(len=1) :: syst_type
    character(len=8) :: resultName
    type(ROM_DS_Field) :: mode
    complex(kind=8), pointer :: modeValeC(:) => null()
    real(kind=8), pointer :: modeValeR(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    syst_type  = multPara%syst_type
    fieldName  = 'DEPL'
    resultName = base%resultName
    mode       = base%mode
    nbEqua     = mode%nbEqua
    ASSERT(mode%fieldSupp .eq. 'NOEU')
!
! - Save mode
!
    if (syst_type .eq. 'C') then
        call jeveuo(modeName(1:19)//'.VALE', 'E', vc = modeValeC)
        normc = zdotc(nbEqua, modeValeC, 1, modeValeC, 1)
        modeValeC(:) = modeValeC(:)/sqrt(normc)
        call romModeSave(resultName, numeMode ,&
                         fieldName , mode     ,&
                         modeValeC_ = modeValeC)
    elseif (syst_type .eq. 'R') then
        call jeveuo(modeName(1:19)//'.VALE', 'E', vr = modeValeR)
        normr = ddot(nbEqua, modeValeR, 1, modeValeR, 1)
        modeValeR(:) = modeValeR(:)/sqrt(normr) 
        call romModeSave(resultName, numeMode ,&
                         fieldName , mode     ,&
                         modeValeR_ = modeValeR)
    else
        ASSERT(ASTER_FALSE)
    endif
!
    base%nbMode = base%nbMode + 1
!
end subroutine
