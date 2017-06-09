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

subroutine ccchuc_ligr(list_elem_stor, nb_elem_old, nb_elem_new, list_elem_new, ligrel_old,&
                       ligrel_new)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/exlim1.h"
#include "asterfort/gnomsd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeexin.h"
#include "asterfort/wkvect.h"
!
!
    character(len=24), intent(in) :: list_elem_stor
    integer, intent(in) :: nb_elem_old
    character(len=24), intent(in) :: list_elem_new
    integer, intent(in) :: nb_elem_new
    character(len=19), intent(in) :: ligrel_old
    character(len=19), intent(out) :: ligrel_new
!
! --------------------------------------------------------------------------------------------------
!
! CALC_CHAMP - CHAM_UTIL - Element field type
!
! Manage <LIGREL> - Create new if necessary
!
! --------------------------------------------------------------------------------------------------
!
! In  list_elem_stor      : object to store list of elements
! In  nb_elem_old    : initial number of elements
! In  nb_elem_new    : new number of elements
! In  list_elem_new  : new list of elements
! In  ligrel_old     : old <LIGREL>
! In  ligrel_new     : new <LIGREL>
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jelem, jlist
    integer :: iret, ima
    aster_logical :: same
    character(len=24) :: noojb
    character(len=8) :: model
!
! --------------------------------------------------------------------------------------------------
!
    same = .true.
    call jeveuo(list_elem_new, 'L', jelem)
    noojb = '12345678.LIGR000000.NBNO'
!
! - Do we need a new <LIGREL> ?
!
    call jeexin(list_elem_stor, iret)
    if (iret .eq. 0) then
        call wkvect(list_elem_stor, 'V V I', nb_elem_old+1, jlist)
        if (nb_elem_new .ne. nb_elem_old) then
            same = .false.
        endif
    else
        call jeveuo(list_elem_stor, 'E', jlist)
        if (zi(jlist-1+1) .ne. nb_elem_new) goto 51
        do ima = 1, nb_elem_new
            if (zi(jlist-1+ima+1) .ne. zi(jelem-1+ima)) then
                same = .false.
                goto 51
            endif
        enddo
 51     continue
        zi(jlist-1+1) = nb_elem_new
        do ima = 1, nb_elem_new
            zi(jlist-1+ima+1) = zi(jelem-1+ima)
        enddo 
    endif 
!
! - Create new <LIGREL> ?
!
    if (same) then
        ligrel_new = ligrel_old
    else
        model = ligrel_old(1:8)
        call gnomsd(' ', noojb, 14, 19)
        ligrel_new = noojb(1:19)
        call exlim1(zi(jelem), nb_elem_new, model, 'G', ligrel_new)
    endif
!
end subroutine
