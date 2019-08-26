! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine nonlinDSErrorIndicRead(ds_errorindic)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
!
type(NL_DS_ErrorIndic), intent(inout) :: ds_errorindic
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Error indicators
!
! Read parameters for error indicator
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_errorindic    : datastructure for error indicator
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: keywf, answer
    integer :: nocc
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE12_12')
    endif
!
! - Read parameters for THM error (Meunier)
!
    keywf  = 'CRIT_QUALITE'
    answer = 'NON'
    call getvtx(keywf, 'ERRE_TEMPS_THM', iocc=1, scal=answer, nbret=nocc)
    ds_errorindic%l_erre_thm = answer .eq. 'OUI'
!
end subroutine
