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

subroutine nmstat_table(ds_measure)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/tbajli.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Measure), intent(in) :: ds_measure
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Measure and statistics management
!
! Update statistics
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_measure       : datastructure for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cols, nb_device
    integer :: i_col, i_para_real, i_para_inte, i_device
    integer :: vali(40)
    character(len=8) :: k8bid
    complex(kind=8), parameter :: c16bid =(0.d0,0.d0)
    real(kind=8) :: valr(40), vale_r
    type(NL_DS_Table) :: table
    type(NL_DS_Column) :: column
    type(NL_DS_Device) :: device
    aster_logical :: l_acti, l_vale_inte, l_vale_real
    integer :: vale_i
    character(len=10) :: device_type
!
! --------------------------------------------------------------------------------------------------
!
    i_para_real = 0
    i_para_inte = 0
    k8bid = ' '
!
! - Get parameters
!
    table     = ds_measure%table
    nb_cols   = table%nb_cols
    nb_device = ds_measure%nb_device
!
! - Set list of values
!
    do i_col = 1, nb_cols
        column   = table%cols(i_col)
        l_acti   = table%l_cols_acti(i_col)
        if (l_acti) then
            i_device    = table%indx_vale(i_col)
            device      = ds_measure%device(i_device)
            device_type = device%type
            l_vale_inte = column%l_vale_inte
            l_vale_real = column%l_vale_real
            if (l_vale_real) then
                vale_r            = column%vale_real
                i_para_real       = i_para_real + 1
                valr(i_para_real) = vale_r
            endif
            if (l_vale_inte) then
                vale_i            = column%vale_inte
                i_para_inte       = i_para_inte + 1
                vali(i_para_inte) = vale_i
            endif
        endif
    end do
!
! - Add line in table
!
    call tbajli(table%table_name, table%nb_para, table%list_para,&
                vali, valr, [c16bid], k8bid, 0)
!
end subroutine
