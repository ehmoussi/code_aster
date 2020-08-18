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
subroutine dbr_para_info_rb(paraRb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romSolveInfo.h"
#include "asterfort/romMultiParaInfo.h"
!
type(ROM_DS_ParaDBR_RB), intent(in) :: paraRb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Print informations about parameters - For GLOUTON method
!
! --------------------------------------------------------------------------------------------------
!
! In  paraRb       : datastructure for parameters (RB)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbModeMaxi
    real(kind=8) :: tole_greedy
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
    nbModeMaxi  = paraRb%nb_mode_maxi
    tole_greedy = paraRb%tole_greedy
!
! - Print - General for RB
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_54', si = nbModeMaxi)
        call utmess('I', 'ROM18_55', sr = tole_greedy)
        call romMultiParaInfo(paraRb%multipara)
        call romSolveInfo(paraRb%algoGreedy%solveDOM)
        call romSolveInfo(paraRb%algoGreedy%solveROM)
    endif
!
end subroutine
