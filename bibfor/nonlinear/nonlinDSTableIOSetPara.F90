! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
                                  nbPara_, paraName_, paraType_)
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
integer, optional :: nbPara_
character(len=24), optional :: paraName_(:)
character(len=8), optional :: paraType_(:)
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
    integer :: nb_cols, nbPara_real, nbPara_inte, nbPara_strg, nb_para, nb_cols_acti
    aster_logical :: l_acti
    character(len=24) :: col_name
!
! --------------------------------------------------------------------------------------------------
!
    i_col        = 0
    nb_para      = 0
    nbPara_inte = 0
    nbPara_real = 0
    nbPara_strg = 0
!
    if (present(table_)) then
        nb_cols      = table_%nb_cols
        nb_cols_acti = 0
        do i_all_col = 1, nb_cols
            if (table_%l_cols_acti(i_all_col)) then
                nb_cols_acti = nb_cols_acti + 1
            endif
        end do
        AS_ALLOCATE(vk24 = table_%table_io%paraName, size = nb_cols_acti)
        AS_ALLOCATE(vk8  = table_%table_io%paraType, size = nb_cols_acti) 
        do i_all_col = 1, nb_cols
            l_acti   = table_%l_cols_acti(i_all_col)
            col_name = table_%cols(i_all_col)%name
            if (l_acti) then
                i_col = i_col + 1
                table_%table_io%paraName(i_col)  = col_name
                if (table_%cols(i_all_col)%l_vale_inte) then
                    table_%table_io%paraType(i_col) = 'I'
                    nb_para          = nb_para + 1
                    nbPara_inte     = nbPara_inte + 1
                elseif (table_%cols(i_all_col)%l_vale_real) then
                    table_%table_io%paraType(i_col) = 'R'
                    nb_para          = nb_para + 1
                    nbPara_real     = nbPara_real + 1
                elseif (table_%cols(i_all_col)%l_vale_strg) then
                    table_%table_io%paraType(i_col) = 'K16'
                    nb_para          = nb_para + 1
                    nbPara_strg     = nbPara_strg + 1
                else
                    ASSERT(ASTER_FALSE)
                endif
            endif
        end do
        ASSERT(nb_para .eq. (nbPara_real + nbPara_inte + nbPara_strg))
        ASSERT(nb_para .le. nb_cols)
        table_%table_io%nbPara     = nb_para
        table_%table_io%nbParaReal = nbPara_real
        table_%table_io%nbParaInte = nbPara_inte
        table_%table_io%nbParaStrg = nbPara_strg
    else
        AS_ALLOCATE(vk24 = tableio_%paraName, size = nbPara_)
        AS_ALLOCATE(vk8  = tableio_%paraType, size = nbPara_) 
        do i_para = 1, nbPara_
            tableio_%paraName(i_para) = paraName_(i_para)
            tableio_%paraType(i_para) = paraType_(i_para)
            if (paraType_(i_para) .eq. 'I') then
                nb_para          = nb_para + 1
                nbPara_inte     = nbPara_inte + 1
            elseif (paraType_(i_para) .eq. 'R') then
                nb_para          = nb_para + 1
                nbPara_real     = nbPara_real + 1           
            elseif (paraType_(i_para)(1:1) .eq. 'K') then
                nb_para          = nb_para + 1
                nbPara_strg     = nbPara_strg + 1
            else
                ASSERT(ASTER_FALSE)
            endif
        end do
        ASSERT(nb_para .eq. (nbPara_real + nbPara_inte + nbPara_strg))
        tableio_%nbPara     = nb_para
        tableio_%nbParaReal = nbPara_real
        tableio_%nbParaInte = nbPara_inte
        tableio_%nbParaStrg = nbPara_strg
    endif
!
end subroutine
    
