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
subroutine nonlinDSPrintTableLine(table, col_sep, unit_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nonlinDSColumnWriteValue.h"
#include "asterfort/utmess.h"
#include "asterfort/PrepareTableLine.h"
!
type(NL_DS_Table), intent(in) :: table
character(len=1), intent(in) :: col_sep
integer, intent(in) :: unit_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table management
!
! Print line of table
!
! --------------------------------------------------------------------------------------------------
!
! In  table            : datastructure for table
! In  col_sep          : separator between columns
! In  unit_print       : logical unit to print
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_col, nb_cols
    type(NL_DS_Column) :: col
    integer :: vali
    integer :: pos, posfin, posmar
    character(len=16) :: chvide
    character(len=24) :: valk, name
    real(kind=8) :: valr
    character(len=512) :: table_line
    integer :: longr, longi
    aster_logical :: l_vale_affe, l_vale_real, l_vale_inte, l_vale_strg
    integer :: col_width, line_width
    character(len=1) :: mark
!
! --------------------------------------------------------------------------------------------------
!
    chvide = ' '
    pos    = 2
    longr  = 12
    longi  = 6
!
! - Get parameters
!
    nb_cols         = table%nb_cols
    line_width      = table%width
    ASSERT(line_width .le. 512)
!
! - Prepare line of table - Void columns
!
    call PrepareTableLine(table, col_sep, table_line)
!
! - Set line with values and marks
!
    do i_col = 1, nb_cols
        if (table%l_cols_acti(i_col)) then
            col         = table%cols(i_col)
            col_width   = 16
            mark        = col%mark
            name        = col%name
            l_vale_affe = col%l_vale_affe
            l_vale_real = col%l_vale_real
            l_vale_inte = col%l_vale_inte
            l_vale_strg = col%l_vale_strg
            posfin      = col_width+pos-1
!
! --------- Set values
!
            if (.not.l_vale_affe) then
                table_line(pos:posfin) = chvide(1:col_width)
            else
                if (l_vale_inte) then
                    vali = col%vale_inte
                    call nonlinDSColumnWriteValue(longi, table_line(pos: posfin),&
                                                  value_i_ = vali)
                else if (l_vale_real) then
                    valr = col%vale_real
                    call nonlinDSColumnWriteValue(longr, table_line(pos: posfin),&
                                                  value_r_ = valr)
                else if (l_vale_strg) then
                    valk = col%vale_strg
                    table_line(pos:posfin) = valk(1:col_width)
                else
                    ASSERT(.false.)
                endif
            endif
!
! --------- Set mark
!
            if (mark(1:1) .ne. ' ') then
                posmar = pos + col_width - 2
                table_line(posmar:posmar) = mark(1:1)
            endif
            pos = pos + col_width + 1
        endif
    end do
!
! - Print
!
    call nonlinDSColumnWriteValue(line_width,  output_unit_ = unit_print, value_k_ = table_line)
!
end subroutine
