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
subroutine nonlinDSTableIOSetPara(table_  ,&
                                  tableio_,&
                                  nb_para_, list_para_, type_para_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
!
type(NL_DS_Table), optional, intent(inout) :: table_
type(NL_DS_TableIO), optional, intent(inout) :: tableio_
integer, optional :: nb_para_
character(len=24), optional :: list_para_(:)
character(len=8), optional :: type_para_(:)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table in output datastructure managemen
!
! Create list of parameters
!
! --------------------------------------------------------------------------------------------------
!
! IO  table            : datastructure for table
! IO  tableio          : table in output datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_all_col, i_col, i_para
    integer :: nb_cols, nb_para_real, nb_para_inte, nb_para_strg, nb_para
    aster_logical :: l_acti
    character(len=24) :: col_name
!
! --------------------------------------------------------------------------------------------------
!
    i_col        = 0
    nb_para      = 0
    nb_para_inte = 0
    nb_para_real = 0
    nb_para_strg = 0
!
    if (present(table_)) then
        nb_cols      = table_%nb_cols
        AS_ALLOCATE(vk24 = table_%table_io%list_para, size = nb_cols)
        AS_ALLOCATE(vk8  = table_%table_io%type_para, size = nb_cols) 
        do i_all_col = 1, nb_cols
            l_acti   = table_%l_cols_acti(i_all_col)
            col_name = table_%cols(i_all_col)%name
            if (l_acti) then
                i_col = i_col + 1
                table_%table_io%list_para(i_col)  = col_name
                if (table_%cols(i_all_col)%l_vale_inte) then
                    table_%table_io%type_para(i_col) = 'I'
                    nb_para          = nb_para + 1
                    nb_para_inte     = nb_para_inte + 1
                elseif (table_%cols(i_all_col)%l_vale_real) then
                    table_%table_io%type_para(i_col) = 'R'
                    nb_para          = nb_para + 1
                    nb_para_real     = nb_para_real + 1
                elseif (table_%cols(i_all_col)%l_vale_strg) then
                    table_%table_io%type_para(i_col) = 'K16'
                    nb_para          = nb_para + 1
                    nb_para_strg     = nb_para_strg + 1
                else
                    ASSERT(ASTER_FALSE)
                endif
            endif
        end do
        ASSERT(nb_para .eq. (nb_para_real + nb_para_inte + nb_para_strg))
        ASSERT(nb_para .le. nb_cols)
        table_%table_io%nb_para      = nb_para
        table_%table_io%nb_para_real = nb_para_real
        table_%table_io%nb_para_inte = nb_para_inte
        table_%table_io%nb_para_strg = nb_para_strg
    else
        AS_ALLOCATE(vk24 = tableio_%list_para, size = nb_para_)
        AS_ALLOCATE(vk8  = tableio_%type_para, size = nb_para_) 
        do i_para = 1, nb_para_
            tableio_%list_para(i_para) = list_para_(i_para)
            tableio_%type_para(i_para) = type_para_(i_para)
            if (type_para_(i_para) .eq. 'I') then
                nb_para          = nb_para + 1
                nb_para_inte     = nb_para_inte + 1
            elseif (type_para_(i_para) .eq. 'R') then
                nb_para          = nb_para + 1
                nb_para_real     = nb_para_real + 1           
            elseif (type_para_(i_para)(1:1) .eq. 'K') then
                nb_para          = nb_para + 1
                nb_para_strg     = nb_para_strg + 1
            else
                ASSERT(ASTER_FALSE)
            endif
        end do
        ASSERT(nb_para .eq. (nb_para_real + nb_para_inte + nb_para_strg))
        tableio_%nb_para      = nb_para
        tableio_%nb_para_real = nb_para_real
        tableio_%nb_para_inte = nb_para_inte
        tableio_%nb_para_strg = nb_para_strg
    endif
!
end subroutine
    