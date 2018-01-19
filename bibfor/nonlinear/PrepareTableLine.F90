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
subroutine PrepareTableLine(table, col_sep, table_line)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
type(NL_DS_Table), intent(in) :: table
character(len=1), intent(in) :: col_sep
character(len=512), intent(out) :: table_line
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table management
!
! Prepare line of table with empty cols
!
! --------------------------------------------------------------------------------------------------
!
! In  table            : datastructure for table
! In  col_sep          : separator between columns
! Out table_line       : line of the table
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_col, nb_cols, width, total_width, line_width
!
! --------------------------------------------------------------------------------------------------
!
    table_line = ' '
!
! - Get parameters
!
    nb_cols         = table%nb_cols
    line_width      = table%width
    ASSERT(line_width .le. 512)
    ASSERT(nb_cols .le. table%nb_cols_maxi)
!
! - Prepare line
!
    table_line(1:1) = col_sep
    total_width     = 1
    do i_col = 1, nb_cols
        if (table%l_cols_acti(i_col)) then
            width       = 16
            total_width = total_width + width + 1
            ASSERT(total_width + width + 1 .le. 512)
            table_line(total_width:total_width) = col_sep
        endif
    end do
!
    ASSERT(total_width.eq.line_width)
!
end subroutine
