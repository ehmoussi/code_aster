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

subroutine ComputeTableHead(table, col_sep, table_head)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/PrepareTableLine.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Table), intent(in) :: table
    character(len=1), intent(in) :: col_sep
    character(len=512), intent(out) :: table_head(3)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table management
!
! Compute head of table
!
! --------------------------------------------------------------------------------------------------
!
! In  table            : datastructure for table
! In  col_sep          : separator between colums
! Out table_head       : head of table
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_col, nb_cols, pos
    integer :: col_width, title_height, table_width
    character(len=16) :: col_title(3)
!
! --------------------------------------------------------------------------------------------------
!
    table_head(1:3) = ' '
!
! - Get parameters
!
    nb_cols      = table%nb_cols
    title_height = table%title_height
    table_width  = table%width
    ASSERT((title_height .gt. 0).and.(title_height .le. 3))
    ASSERT(table_width .le. 512)
    ASSERT(nb_cols .le. table%nb_cols_maxi)
!
! - Prepare heads of table with empty cols
!
    call PrepareTableLine(table, col_sep, table_head(1))
    if (title_height .ge. 2) then
        call PrepareTableLine(table, col_sep, table_head(2))
    endif
    if (title_height .eq. 3) then
        call PrepareTableLine(table, col_sep, table_head(3))
    endif
!
! - Set title of columns in heads of table
!
    pos = 2
    do i_col = 1, nb_cols
        if (table%l_cols_acti(i_col)) then
            col_width    = 16
            col_title(1) = table%cols(i_col)%title(1)
            if (title_height .ge. 2) then
                col_title(2) = table%cols(i_col)%title(2)
            endif
            if (title_height .eq. 3) then
                col_title(3) = table%cols(i_col)%title(3)
            endif
            table_head(1)(pos:pos+col_width-1) = col_title(1)
            if (title_height .ge. 2) then
                table_head(2)(pos:pos+col_width-1) = col_title(2)
            endif
            if (title_height .eq. 3) then
                table_head(3)(pos:pos+col_width-1) = col_title(3)
            endif
            pos = pos+col_width+1
        endif
    end do
!
    ASSERT(pos.eq.table_width+1)
!
end subroutine
