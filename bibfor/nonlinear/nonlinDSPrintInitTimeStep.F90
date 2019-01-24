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
subroutine nonlinDSPrintInitTimeStep(ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/ComputeTableWidth.h"
#include "asterfort/SetTableColumn.h"
!
type(NL_DS_Print), intent(inout) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Print management
!
! Initializations for convergence table
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_col, line_width, i, nb_cols_active
    type(NL_DS_Table) :: table_cvg
    aster_logical :: l_info_time, l_csv
    character(len=512) :: sep_line
!
! --------------------------------------------------------------------------------------------------
!
    sep_line = ' '
!
! - Get convergence table
!
    table_cvg   = ds_print%table_cvg
!
! - Get parameters
!
    l_info_time = ds_print%l_info_time
    l_csv       = ds_print%l_tcvg_csv
!
! - Measure time
!
    if (l_csv) then
        call SetTableColumn(table_cvg, name_ = 'INCR_INST', flag_acti_ = ASTER_TRUE)
    else
        call SetTableColumn(table_cvg, name_ = 'INCR_INST', flag_acti_ = ASTER_FALSE)
    endif
    if (l_info_time) then
        call SetTableColumn(table_cvg, name_ = 'ITER_TIME', flag_acti_ = ASTER_TRUE)
    else
        call SetTableColumn(table_cvg, name_ = 'ITER_TIME', flag_acti_ = ASTER_FALSE)
    endif
!
! - Compute width of table
!
    call ComputeTableWidth(table_cvg, line_width, nb_cols_active)
    if (line_width .gt. 255) then
        call utmess('F', 'IMPRESSION_2', si = line_width)
    endif
    if (nb_cols_active .ge. 15) then
        call utmess('F', 'IMPRESSION_1', si = nb_cols_active)
    endif
!
! - Compute separator line
!
    do i = 1, line_width
        sep_line(i:i) = '-'
    end do
    table_cvg%width    = line_width
    table_cvg%sep_line = sep_line
    ds_print%sep_line  = sep_line
!
! - No value affected in column
!
    do i_col = 1, table_cvg%nb_cols
        table_cvg%cols(i_col)%l_vale_affe = ASTER_FALSE
    end do
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
