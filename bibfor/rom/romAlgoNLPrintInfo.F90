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
subroutine romAlgoNLPrintInfo(paraAlgo)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/romBasePrintInfo.h"
!
type(ROM_DS_AlgoPara), intent(in) :: paraAlgo
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Print informations about non-linear parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  paraAlgo         : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_hrom, l_hrom_corref
!
! --------------------------------------------------------------------------------------------------
!
    l_hrom        = paraAlgo%l_hrom
    l_hrom_corref = paraAlgo%l_hrom_corref
    if (l_hrom) then
        call utmess('I', 'ROM5_82')
        if (l_hrom_corref) then
            call utmess('I', 'ROM5_84')
            call utmess('I', 'ROM5_85', sr = paraAlgo%vale_pena)
        endif
    else
        call utmess('I', 'ROM5_83')
    endif
    call utmess('I', 'ROM5_81')
    call romBasePrintInfo(paraAlgo%ds_empi)
!
end subroutine
