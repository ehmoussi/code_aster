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
subroutine dbrParaInfoGreedy(paraGreedy)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/romMultiParaInfo.h"
#include "asterfort/romSolveInfo.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_Greedy), intent(in) :: paraGreedy
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Print informations about parameters - For greedy method
!
! --------------------------------------------------------------------------------------------------
!
! In  paraGreedy       : datastructure for parameters (Greedy)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbModeMaxi
    real(kind=8) :: toleGreedy
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_53')
    endif
!
! - Get parameters
!
    nbModeMaxi = paraGreedy%nbModeMaxi
    toleGreedy = paraGreedy%toleGreedy
!
! - Print - General for RB
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_54', si = nbModeMaxi)
        call utmess('I', 'ROM18_55', sr = toleGreedy)
        call romMultiParaInfo(paraGreedy%multiPara)
        call romSolveInfo(paraGreedy%algoGreedy%solveDOM)
        call romSolveInfo(paraGreedy%algoGreedy%solveROM)
    endif
!
end subroutine
