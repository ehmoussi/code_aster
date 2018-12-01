! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine nonlinDSPrintSepLine()
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nonlinDSColumnWriteValue.h"
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table management
!
! Print line for separation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: line_width
    character(len=512) :: sep_line
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    sep_line   = &
'=================================================================================================='
    line_width = 98
    call nonlinDSColumnWriteValue(line_width,&
                                  output_unit_ = ifm,&
                                  value_k_     = sep_line)
!
end subroutine
