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
!
subroutine tbGetListPara(tabl_namez, nb_para, v_list_para, v_type_para, nb_line)
!
implicit none
!
#include "asterfort/jeveuo.h"
#include "asterfort/tbtri.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
character(len=*), intent(in) :: tabl_namez
integer, intent(out) :: nb_para
character(len=24), pointer :: v_list_para(:)
character(len=24), pointer :: v_type_para(:)
integer, intent(out) :: nb_line
!
! --------------------------------------------------------------------------------------------------
!
! Table
!
! Get list of all parameters in table
!
! --------------------------------------------------------------------------------------------------
!
! In  tabl_name        : name of table
! Out nb_para          : number of parameters
! Out v_list_para      : list of name of parameters (by alphabetical order)
! Out v_type_para      : list of type of parameters
! Out nb_line          : number of lines
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24), pointer :: v_tblp(:) => null()
    integer, pointer :: v_tbnp(:) => null()
    integer :: i_para
    character(len=19) :: tabl_name
    character(len=24), pointer :: v_list_par1(:) => null()
    integer, pointer :: v_tabint(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    tabl_name = tabl_namez
    nb_para   = 0
    nb_line   = 0
!
! - Access to objects
!
    call jeveuo(tabl_name(1:19)//'.TBLP', 'E', vk24=v_tblp)
    call jeveuo(tabl_name(1:19)//'.TBNP', 'E', vi=v_tbnp)
!
! - Main parameters of table
!
    nb_para = v_tbnp(1)
    nb_line = v_tbnp(2)
!
! - Get parameters of table
!
    if (nb_para .ne. 0) then
        AS_ALLOCATE(vk24=v_type_para, size = nb_para)
        AS_ALLOCATE(vk24=v_list_para, size = nb_para)
        AS_ALLOCATE(vk24=v_list_par1, size = nb_para)
        AS_ALLOCATE(vi=v_tabint, size = nb_para)
        do i_para = 1, nb_para
            v_list_par1(i_para) = v_tblp(1+4*(i_para-1))
        end do
        call tbtri(nb_para, tabint = v_tabint, tabchk = v_list_par1)
        do i_para = 1, nb_para
            v_list_para(i_para) = v_list_par1(v_tabint(i_para))
            v_type_para(i_para) = v_tblp(1+4*(v_tabint(i_para)-1)+1)
        end do
        AS_DEALLOCATE(vk24=v_list_par1)
        AS_DEALLOCATE(vi=v_tabint)
    endif
!
end subroutine
