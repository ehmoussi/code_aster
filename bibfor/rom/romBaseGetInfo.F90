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
subroutine romBaseGetInfo(resultName, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
#include "asterfort/romModeParaRead.h"
#include "asterfort/rs_getfirst.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rsexch.h"
#include "asterfort/romFieldGetInfo.h"
!
character(len=8), intent(in)     :: resultName
type(ROM_DS_Empi), intent(inout) :: base
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get informations about base
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of result datastructure
! IO  base             : datastructure for base
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: numeModeRefe = 1
    integer :: iret, numeModeFirst, numeSlice, nbSnap, nbMode
    character(len=8)  :: model, axe_line, baseType
    character(len=24) :: surf_num, fieldRefe, modeSymbName
    type(ROM_DS_Field) :: mode
!
! --------------------------------------------------------------------------------------------------
!
    nbMode       = 0
    model        = ' '
    axe_line     = ' '
    baseType     = ' '
    surf_num     = ' '
    fieldRefe    = ' '
    modeSymbName = ' '
!
! - Number of modes
!
    call rs_get_liststore(resultName, nbMode)
!
! - Get main parameters in empiric resultName
!
    call romModeParaRead(resultName, numeModeRefe,&
                         model_        = model,&
                         modeSymbName_ = modeSymbName,&
                         numeSlice_    = numeSlice,&
                         nbSnap_       = nbSnap)
    if (numeSlice .ne. 0) then
        baseType = 'LINEIQUE'
    endif
!
! - Get _representative_ field in empiric result
!
    call rs_getfirst(resultName, numeModeFirst)
    call rsexch(' ', resultName, modeSymbName, numeModeFirst, fieldRefe, iret)
    ASSERT(iret .eq. 0)
!
! - Get informations from mode
!
    call romFieldGetInfo(model, modeSymbName, fieldRefe, mode)
!
! - Save informations about empiric modes
!
    base%base       = resultName
    base%base_type  = baseType
    base%axe_line   = axe_line
    base%surf_num   = surf_num
    base%nb_mode    = nbMode
    base%nb_snap    = nbSnap
    base%ds_mode    = mode
!
end subroutine
