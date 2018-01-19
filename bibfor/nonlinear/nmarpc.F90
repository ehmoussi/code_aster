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
subroutine nmarpc(ds_energy, nume_reuse, time_curr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/tbajli.h"
#include "asterfort/GetEnergy.h"
!
type(NL_DS_Energy), intent(in) :: ds_energy
integer, intent(in) :: nume_reuse
real(kind=8), intent(in) :: time_curr
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Storing results
!
! Save energy parameters in output table
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_energy        : datastructure for energy management
! In  nume_reuse       : index for reuse rsults datastructure
! In  time_curr        : current time
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cols, i_col, i_para_real
    integer :: vali(1)
    character(len=8) :: k8bid = ' '
    complex(kind=8), parameter :: c16bid =(0.d0,0.d0)
    real(kind=8) :: valr(7), vale_r
    type(NL_DS_Table) :: table
    type(NL_DS_Column) :: column
    aster_logical :: l_acti
!
! --------------------------------------------------------------------------------------------------
!
    table    = ds_energy%table
!
! - Get table parameters
!
    nb_cols  = table%nb_cols
!
! - Set values
!
    i_para_real = 0
    do i_col = 1, nb_cols
        column = table%cols(i_col)
        l_acti = table%l_cols_acti(i_col)
        if (l_acti) then
            if (column%name .eq. 'NUME_REUSE') then
                vali(1)           = nume_reuse
            elseif (column%name .eq. 'INST') then
                i_para_real       = i_para_real + 1
                valr(i_para_real) = time_curr
            else
                vale_r            = table%cols(i_col)%vale_real
                i_para_real       = i_para_real + 1
                valr(i_para_real) = vale_r
            endif
        endif
    end do
!
! - Add line in table
!
    call tbajli(table%table_io%table_name, table%table_io%nb_para, table%table_io%list_para,&
                vali, valr, [c16bid], k8bid, 0)
!
end subroutine
