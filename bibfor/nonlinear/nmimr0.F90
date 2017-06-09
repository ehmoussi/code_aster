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

subroutine nmimr0(ds_print, loop_name)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/SetTableColumn.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Print), intent(inout) :: ds_print
    character(len=4), intent(in) :: loop_name
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Set values are not affected on cols for a loop level
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_print         : datastructure for printing parameters
! In  loop_name        : name of loop
!                         'RESI' - Loop on residuals
!                         'NEWT' - Newton loop
!                         'FIXE' - Fixed points loop
!                         'INST' - Step time loop
!                         'CALC' - Computation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_col, nb_cols
    character(len=24) :: col_name
    type(NL_DS_Table) :: table_cvg
!
! --------------------------------------------------------------------------------------------------
!
    table_cvg = ds_print%table_cvg
    nb_cols   = table_cvg%nb_cols
!
! - No value affected in row for loop level
!
    do i_col = 1, nb_cols
        if (table_cvg%l_cols_acti(i_col)) then
            col_name = table_cvg%cols(i_col)%name
            if (loop_name .eq. col_name(1:4)) then
                call SetTableColumn(table_cvg, name_ = col_name, flag_affe_ = .false._1)
            endif
        endif
    end do
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
