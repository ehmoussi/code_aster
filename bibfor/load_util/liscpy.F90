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

subroutine liscpy(list_load_in, list_load_out, base)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/liscad.h"
#include "asterfort/lisccr.h"
#include "asterfort/liscli.h"
#include "asterfort/lisnch.h"
!
!
    character(len=19), intent(in) :: list_load_in
    character(len=19), intent(in) :: list_load_out
    character(len=1), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Special copy (DO NOT KEEP "ELEM_TARDIF" loads)
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load_in      : list of loads to copy
! In  list_load_out     : list of loads to save
! In  base              : JEVEUX base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_info_maxi
    parameter   (nb_info_maxi=99)
    character(len=24) :: list_info_type(nb_info_maxi)
!
    integer :: nb_load_in, i_load_in, i_load_out, nb_load_out, i_neum_lapl, i_type_info
    character(len=8) :: load_name, load_func
    integer :: nb_info_type
    character(len=24) :: lload_info
    integer, pointer :: v_load_info(:) => null()
    integer, pointer :: v_load_info_out(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Datastructure access
!
    lload_info = list_load_in(1:19)//'.INFC'
    call jeveuo(lload_info, 'L', vi   = v_load_info)
!
    nb_load_in = v_load_info(1)
!
    if (nb_load_in .eq. 0) then
        call lisccr('MECA', list_load_out, 1, base)
        call jeveuo(list_load_out(1:19)//'.INFC', 'E', vi = v_load_info_out)
        v_load_info_out(1) = 0
        goto 999
    else
        call lisnch(list_load_in, nb_load_in)
        nb_load_out = nb_load_in
    endif
!
! - Don't keep "ELEM_TARDIF" load type
!
    do i_load_in = 1, nb_load_in
        i_type_info = v_load_info(nb_load_in+i_load_in+1)
        if (i_type_info .eq. 10) then
            nb_load_out = nb_load_out-1
        endif
    end do
!
! - No loads but contact method
!
    if (nb_load_out.le.0) then
        call lisccr('MECA', list_load_out, 1, base)
        call jeveuo(list_load_out(1:19)//'.INFC', 'E', vi = v_load_info_out)
        v_load_info_out(1) = 0
        goto 999
    endif
!
    ASSERT(nb_load_out.gt.0)
    ASSERT(nb_load_out.le.nb_load_in)
!
! - Create new Datastructure
!
    call lisccr('MECA', list_load_out, nb_load_out, base)
!
! - Copy all loads except "ELEM_TARDIF" load type
!
    i_load_out = 1
    do i_load_in = 1, nb_load_in
        i_type_info = v_load_info(nb_load_in+i_load_in+1)
        if (i_type_info .ne. 10) then
            call liscli(list_load_in  , i_load_in   , nb_info_maxi  , list_info_type, load_name,&
                        load_func     , nb_info_type, i_neum_lapl)
            call liscad('MECA'      , list_load_out , i_load_out  , load_name, load_func,&
                        nb_info_type, list_info_type, i_neum_laplz = i_neum_lapl)
            i_load_out = i_load_out + 1
        endif
    end do
!
    ASSERT(nb_load_out.eq.(i_load_out-1))
!
999 continue
    call jedema()
end subroutine
