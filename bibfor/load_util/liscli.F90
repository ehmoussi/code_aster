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

subroutine liscli(list_load  , i_load      , nb_info_maxi, list_info_type, load_namez,&
                  load_funcz , nb_info_type, i_neum_lapl)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
!
    character(len=19), intent(in) :: list_load
    integer, intent(in) :: i_load
    integer, intent(in) :: nb_info_maxi
    character(len=24), intent(inout) :: list_info_type(nb_info_maxi)
    character(len=*), intent(out) :: load_namez
    character(len=*), intent(out) :: load_funcz
    integer, intent(out) :: nb_info_type
    integer, intent(out) :: i_neum_lapl
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Read load in list
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load      : list of loads
! In  i_load         : index in list
! Out load_name      : name of load
! Out load_func      : name of function
! In  nb_info_maxi   : maximum length of list_info_type
! Out nb_info_type   : number of type of loads to assign (list)
! IO  list_info_type : list of type of loads to assign (list)
! Out i_neum_lapl    : special index for Laplace load
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: lload_name, lload_info, lload_func
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
    character(len=24), pointer :: v_load_func(:) => null()
    integer :: nb_load, i_info_type
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Datastructure access
!
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
    lload_func = list_load(1:19)//'.FCHA'
    call jeveuo(lload_name, 'L', vk24 = v_load_name)
    call jeveuo(lload_info, 'L', vi   = v_load_info)
    call jeveuo(lload_func, 'L', vk24 = v_load_func)
    nb_load = v_load_info(1)
    ASSERT(i_load.gt.0)
    ASSERT(i_load.le.nb_load)
!
    load_namez   = v_load_name(i_load)(1:8)
    load_funcz   = v_load_func(i_load)
    list_info_type(1:nb_info_maxi) = ' '
    i_neum_lapl  = 0
    nb_info_type = 0
    i_info_type  = 0
!
! - Get load name for undead Dirichlet loads
!
    if (v_load_info(i_load+1) .eq. 4) then
        load_namez = v_load_name(i_load)(9:16)
    endif
!
    if (v_load_info(i_load+1) .eq. 4) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'DIRI_SUIV'
    endif
!
    if (v_load_info(i_load+1) .eq. -1) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'CINE_CSTE'
    endif
!
    if (v_load_info(i_load+1) .eq. -2) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'CINE_FO'
    endif
!
    if (v_load_info(i_load+1) .eq. -3) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'CINE_FT'
    endif
!
    if (v_load_info(i_load+1) .eq. 5) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'DIRI_PILO'
    endif
!
    if (v_load_info(i_load+1) .eq. 6) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'DIRI_PILO_F'
    endif
!
    if (v_load_info(i_load+1) .eq. 1) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'DIRI_CSTE'
        if (v_load_info(3*nb_load+2+i_load+1) .eq. 1) then
            list_info_type(i_info_type) = list_info_type(i_info_type)(1:9)//'_DIDI'
        endif
    endif
!
    if (v_load_info(i_load+1) .eq. 2) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'DIRI_FO'
        if (v_load_info(3*nb_load+2+i_load+1) .eq. 1) then
            list_info_type(i_info_type) = list_info_type(i_info_type)(1:9)//'_DIDI'
        endif
    endif
!
    if (v_load_info(i_load+1) .eq. 3) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'DIRI_FT'
        if (v_load_info(3*nb_load+2+i_load+1) .eq. 1) then
            list_info_type(i_info_type) = list_info_type(i_info_type)(1:9)//'_DIDI'
        endif
    endif
!
    if (v_load_info(nb_load+i_load+1) .eq. 6) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_ONDE'
    endif
!
    if (v_load_info(nb_load+i_load+1) .eq. 7) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_ONDF'
    endif
!
    if ((v_load_info(nb_load+i_load+1) .eq. 55) .and. (v_load_info(4*nb_load+5) .eq. 99) ) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_SIGM_INT'
    endif
!
    if (v_load_info(nb_load+i_load+1) .eq. 5) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_PILO'
    endif
!
    if (v_load_info(nb_load+i_load+1) .eq. 4) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_SUIV'
    endif
!
    if (v_load_info(nb_load+i_load+1) .eq. 2) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_FO'
    endif
!
    if (v_load_info(nb_load+i_load+1) .eq. 3) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_FT'
    endif
!
    if (v_load_info(nb_load+i_load+1) .eq. 1) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_CSTE'
    endif
!
    if (v_load_info(2*nb_load+3) .ne. 0) then
        i_info_type = i_info_type+1
        ASSERT(i_info_type.le.nb_info_maxi)
        list_info_type(i_info_type) = 'NEUM_LAPL'
        i_neum_lapl = v_load_info(2*nb_load+3)
    endif
!
    nb_info_type = i_info_type
!
    call jedema()
end subroutine
