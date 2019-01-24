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
subroutine nonlinDSPrintCreate(phenom, ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nonlinDSPrintCreate_M.h"
!#include "asterfort/nonlinDSPrintCreate_T.h"
!
character(len=4), intent(in) :: phenom
type(NL_DS_Print), intent(out) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Print management
!
! Create printing datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom           : phenomenon (MECA/THNL)
! Out ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    if (phenom .eq. 'MECA') then
        call nonlinDSPrintCreate_M(ds_print)
    elseif (phenom.eq.'THNL') then
        ASSERT(ASTER_FALSE)
        !call nonlinDSPrintCreate_T(ds_print)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
