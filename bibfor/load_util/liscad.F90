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

subroutine liscad(phenom       , list_load      , i_load    , load_namez  , load_funcz,&
                  nb_info_typez, list_info_typez, info_typez, i_neum_laplz)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/gcnco2.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
!
    character(len=4), intent(in) :: phenom
    character(len=19), intent(in) :: list_load
    integer, intent(in) :: i_load
    character(len=*), intent(in) :: load_namez
    character(len=*), intent(in) :: load_funcz
    integer, optional, intent(in) :: nb_info_typez
    character(len=*), optional, intent(in) :: list_info_typez(*)
    character(len=*), optional, intent(in) :: info_typez
    integer, optional, intent(in) :: i_neum_laplz
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Add new load(s) in list
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom         : phenomenon (MECA/THER/ACOU)
! In  list_load      : name of datastructure for list of loads
! In  i_load         : index in list
! In  load_name      : name of load
! In  load_func      : name of function
! In  nb_info_type   : number of type of loads to assign (list)
! In  list_info_type : list of type of loads to assign (list)
! In  info_type      : type of load to assign (only one)
! In  i_neum_lapl    : special index for Laplace load
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_load, i_info_type, nb_info_type
    character(len=24) :: info_type
    character(len=24) :: lload_name, lload_info, lload_func
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
    character(len=24), pointer :: v_load_func(:) => null()
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
    call jeveuo(lload_name, 'E', vk24 = v_load_name)
    call jeveuo(lload_info, 'E', vi   = v_load_info)
    call jeveuo(lload_func, 'E', vk24 = v_load_func)
!
! - Datastructure informations
!
    nb_load = v_load_info(1)
    ASSERT(i_load.gt.0)
    ASSERT(i_load.le.nb_load)
!
! - Set basic properties of load
!
    v_load_name(i_load) = load_namez
    v_load_func(i_load) = load_funcz
!
! - List or not ?
!
    if (present(nb_info_typez)) then
        nb_info_type = nb_info_typez
    else
        nb_info_type = 1
    endif
!
! - Set type of load
!
    if (phenom.eq.'MECA') then
        do i_info_type = 1, nb_info_type
            if (present(info_typez)) then
                info_type = info_typez
            else
                info_type = list_info_typez(i_info_type)
            endif
            if (info_type .eq. 'CINE_CSTE') then
                v_load_info(i_load+1) = -1
            else if (info_type.eq.'CINE_FO') then
                v_load_info(i_load+1) = -2
            else if (info_type.eq.'CINE_FT') then
                v_load_info(i_load+1) = -3
            else if (info_type.eq.'DIRI_PILO ') then
                v_load_info(i_load+1) = 5
            else if (info_type.eq.'DIRI_PILO_F') then
                v_load_info(i_load+1) = 6
            else if (info_type(1:9).eq.'DIRI_CSTE') then
                v_load_info(i_load+1) = 1
                if (info_type(10:15) .eq. '_DIDI') then
                    v_load_info(3*nb_load+2+i_load+1) = 1
                endif
            else if (info_type(1:9).eq.'DIRI_FO') then
                v_load_info(i_load+1) = 2
                if (info_type(10:15) .eq. '_DIDI') then
                    v_load_info(3*nb_load+2+i_load+1) = 1
                endif
            else if (info_type(1:9).eq.'DIRI_FT') then
                v_load_info(i_load+1) = 3
                if (info_type(10:15) .eq. '_DIDI') then
                    v_load_info(3*nb_load+2+i_load+1) = 1
                endif
            else if (info_type.eq.'DIRI_SUIV') then
                v_load_info(i_load+1) = 4
            else if (info_type.eq.'NEUM_ONDE') then
                v_load_info(nb_load+i_load+1) = 6
            else if (info_type.eq.'NEUM_ONDF') then
                v_load_info(nb_load+i_load+1) = 7
            else if (info_type.eq.'NEUM_SIGM_INT') then
                v_load_info(nb_load+i_load+1) = 55
                v_load_info(4*nb_load+5) = 99
            else if (info_type.eq.'NEUM_PILO') then
                v_load_info(nb_load+i_load+1) = 5
                v_load_info(4*nb_load+5) = 99
            else if (info_type.eq.'NEUM_PILO_F') then
                v_load_info(nb_load+i_load+1) = 8
            else if (info_type.eq.'NEUM_SUIV') then
                v_load_info(nb_load+i_load+1) = 4
            else if (info_type.eq.'NEUM_FO') then
                v_load_info(nb_load+i_load+1) = 2
            else if (info_type.eq.'NEUM_FT') then
                v_load_info(nb_load+i_load+1) = 3
            else if (info_type.eq.'NEUM_CSTE') then
                v_load_info(nb_load+i_load+1) = 1
            else if (info_type.eq.'NEUM_LAPL') then
                v_load_info(2*nb_load+3) = i_neum_laplz
            else if (info_type.eq.'ELEM_TARDIF') then
                v_load_info(nb_load+i_load+1) = 10
            else if (info_type.eq.'EXCIT_SOL') then
                v_load_info(nb_load+i_load+1) = 20
            else
                write(6,*) 'LISCAD: ',info_type
                ASSERT(.false.)
            endif
        end do
    elseif (phenom.eq.'THER') then
        do i_info_type = 1, nb_info_type
            if (present(info_typez)) then
                info_type = info_typez
            else
                info_type = list_info_typez(i_info_type)
            endif
            if (info_type .eq. 'CINE_CSTE') then
                v_load_info(i_load+1) = -1
            else if (info_type.eq.'CINE_FO') then
                v_load_info(i_load+1) = -2
            else if (info_type.eq.'CINE_FT') then
                v_load_info(i_load+1) = -3
            else if (info_type(1:9).eq.'DIRI_CSTE') then
                v_load_info(i_load+1) = 1
            else if (info_type(1:9).eq.'DIRI_FO') then
                v_load_info(i_load+1) = 2
            else if (info_type(1:9).eq.'DIRI_FT') then
                v_load_info(i_load+1) = 3
            else if (info_type.eq.'NEUM_CSTE') then
                v_load_info(nb_load+i_load+1) = 1
            else if (info_type.eq.'NEUM_FO') then
                v_load_info(nb_load+i_load+1) = 2
            else if (info_type.eq.'NEUM_FT') then
                v_load_info(nb_load+i_load+1) = 3
            else
                write(6,*) 'LISCAD: ',info_type
                ASSERT(.false.)
            endif
        end do
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
