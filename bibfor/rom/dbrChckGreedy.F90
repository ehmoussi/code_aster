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
subroutine dbrChckGreedy(paraGreedy, lReuse)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/romMultiParaChck.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_Greedy), intent(in) :: paraGreedy
aster_logical, intent(in) :: lReuse
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Some checks - For greedy method
!
! --------------------------------------------------------------------------------------------------
!
! In  paraGreedy       : datastructure for parameters (Greedy)
! In  lReuse           : .true. if reuse
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16), parameter :: operation = 'GLOUTON'
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','ROM18_39')
    endif
!
! - General check
!
    if (lReuse) then
        call utmess('F','ROM18_38', sk = operation)
    endif
!
! - Check data for multiparametric problems
!
    call romMultiParaChck(paraGreedy%multiPara, paraGreedy%lStabFSI)
!
! - Specific checks for DEFI_BASE_REDUITE
!
    if (paraGreedy%multiPara%nb_vari_coef .eq. 0) then
        call utmess('F', 'ROM18_40')
    endif
!
! - Only on nodal fields
!
    if (paraGreedy%multiPara%field%fieldSupp .ne. 'NOEU') then
        call utmess('F','ROM18_41', sk = paraGreedy%multiPara%field%fieldSupp)
    endif
!
end subroutine
