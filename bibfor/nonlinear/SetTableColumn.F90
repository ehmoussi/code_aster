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

subroutine SetTableColumn(table     , name_ , flag_acti_,&
                          flag_affe_, valer_, valei_    , valek_, mark_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Table), intent(inout) :: table
    character(len=*), optional, intent(in) :: name_
    aster_logical, optional, intent(in) :: flag_acti_
    aster_logical, optional, intent(in) :: flag_affe_
    real(kind=8), optional, intent(in) :: valer_
    integer, optional, intent(in) :: valei_
    character(len=*), optional, intent(in) :: valek_
    character(len=1), optional, intent(in) :: mark_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table management
!
! Set column in table
!
! --------------------------------------------------------------------------------------------------
!
! IO  table            : datastructure for table
! In  name             : name of column 
!                        If .not. present => all columns
! In  flag_acti        : flag for activation of column
! In  valer            : value (real) for column
! In  valei            : value (integer) for column
! In  valek            : value (string) for column
! In  flag_affe        : flag for value set in column
! In  mark             : mark for column
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_col, nb_cols, i_col_name
!
! --------------------------------------------------------------------------------------------------
!
    i_col_name    = 0
    nb_cols       = table%nb_cols
!
! - On all cols
!
    if (.not.present(name_)) then
        do i_col = 1, nb_cols
            if (present(flag_acti_)) then
                table%l_cols_acti(i_col) = flag_acti_
            endif
            if (present(mark_)) then
                table%cols(i_col)%mark = mark_
            endif
            ASSERT(.not.present(valer_))
            ASSERT(.not.present(valei_))
            ASSERT(.not.present(valek_))
            ASSERT(.not.present(flag_affe_))
        end do
    endif
!
! - On one column
!
    if (present(name_)) then
        do i_col = 1, nb_cols
            if (table%cols(i_col)%name .eq. name_) then
                ASSERT(i_col_name.eq.0)
                i_col_name = i_col   
            endif
        end do
        ASSERT(i_col_name.ne.0)
        if (present(mark_)) then
            table%cols(i_col_name)%mark = mark_
        endif
        if (present(flag_acti_)) then
            table%l_cols_acti(i_col_name) = flag_acti_
        endif
        if (present(flag_affe_)) then
            table%cols(i_col_name)%l_vale_affe = flag_affe_
        endif
        if (present(valer_)) then
            table%cols(i_col_name)%vale_real = valer_
            ASSERT(table%cols(i_col_name)%l_vale_real)
        endif
        if (present(valei_)) then
            table%cols(i_col_name)%vale_inte = valei_
            ASSERT(table%cols(i_col_name)%l_vale_inte)
        endif
        if (present(valek_)) then
            table%cols(i_col_name)%vale_strg = valek_
            ASSERT(table%cols(i_col_name)%l_vale_strg)
        endif
    endif
!
end subroutine
