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
subroutine nmimpr(ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nonlinDSPrintTableLine.h"
#include "asterfort/iunifi.h"
!
type(NL_DS_Print), intent(in) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Print line in convergence table
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_csv
    integer :: unit_mess, unit_csv
    character(len=1) :: row_sep
    type(NL_DS_Table) :: table_cvg
!
! --------------------------------------------------------------------------------------------------
!
    unit_mess = iunifi('MESSAGE')
!
! - Get convergence table
!
    table_cvg = ds_print%table_cvg
!
! - Get parameters
!
    l_csv     = ds_print%l_tcvg_csv
    unit_csv  = ds_print%tcvg_unit
!
! - Print in message unit
!
    row_sep = '|'
    if (ds_print%l_print) then
        call nonlinDSPrintTableLine(table_cvg, row_sep, unit_mess)
    endif
!
! - Print in file
!
    if (l_csv) then
        row_sep = ','
        call nonlinDSPrintTableLine(table_cvg, row_sep, unit_csv)
    endif
!
end subroutine
