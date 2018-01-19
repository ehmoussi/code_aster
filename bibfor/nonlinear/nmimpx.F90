! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
subroutine nmimpx(ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nonlinDSColumnWriteValue.h"
#include "asterfort/iunifi.h"
!
type(NL_DS_Print), intent(in) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Print separation line
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: line_width
    character(len=512) :: sep_line
    integer :: mesg_unit
!
! --------------------------------------------------------------------------------------------------
!
    mesg_unit       = iunifi('MESSAGE')
!
! - Get parameters
!
    sep_line        = ds_print%table_cvg%sep_line
    line_width      = ds_print%table_cvg%width
!
! - Print line
!
    call nonlinDSColumnWriteValue(line_width,&
                                  output_unit_ = mesg_unit,&
                                  value_k_     = sep_line)
!
end subroutine
