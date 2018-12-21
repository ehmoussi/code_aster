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
function iden_nume(pchn1, pchn2)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
aster_logical :: iden_nume
character(len=*), intent(in) :: pchn1, pchn2
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: ob1, ob2, k241, k242
    integer :: l1, l2, k1, k2
    aster_logical :: l_iden
!
! --------------------------------------------------------------------------------------------------
!
    iden_nume = ASTER_TRUE
    ob1 = pchn1(1:19)//'.LILI'
    ob2 = pchn2(1:19)//'.LILI'
    call jelira(ob1, 'NOMUTI', l1)
    call jelira(ob2, 'NOMUTI', l2)
    if (l1 .ne. l2) then
        iden_nume = ASTER_FALSE
        goto 999
    endif
!
    do k1 = 1, l1
        call jenuno(jexnum(ob1, k1), k241)
        l_iden = ASTER_FALSE
        do k2 = 1, l2
            call jenuno(jexnum(ob2, k2), k242)
            if (k241 .eq. k242) then
                l_iden = ASTER_TRUE
                exit
            endif
        end do
        if (.not. l_iden) then
            iden_nume = ASTER_FALSE
            goto 999
        endif
    end do
!
999 continue
!
end function
