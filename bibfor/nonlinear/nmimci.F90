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

subroutine nmimci(ds_print, col_name_, vali, l_affe)
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
    character(len=*), intent(in) :: col_name_
    integer, intent(in) :: vali
    aster_logical, intent(in) :: l_affe
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Set value in column of convergence table - Integer
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_print         : datastructure for printing parameters
! In  col_name         : name of column 
! In  flag             : .true. for activation of column
! In  vali             : value (integer) for column
!
! --------------------------------------------------------------------------------------------------
!
    type(NL_DS_Table) :: table_cvg
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get convergence table
!
    table_cvg = ds_print%table_cvg
!
! - Set and activate value
!
    call SetTableColumn(table_cvg, name_ = col_name_,&
                        flag_affe_ = l_affe, valei_ = vali)
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
