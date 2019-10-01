! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
function getResuElem(matr_elem_, vect_elem_)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jevech.h"
#include "asterfort/jeveuo.h"
#include "asterfort/zerosd.h"
!
!
    character(len=19), intent(in), optional :: matr_elem_
    character(len=19), intent(in), optional :: vect_elem_
    character(len=19)                       :: getResuElem
!
! --------------------------------------------------------------------------------------------------
!
! Generic routines
!
! Get RESU_ELEM from vect_elem or matr_elem
!
! --------------------------------------------------------------------------------------------------
!
!   In vect_elem    : name of VECT_ELEM
!   In matr_elem    : name of MATR_ELEM
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nb_resu
    character(len=24) :: enti_elem = ' '
    character(len=19) :: resu_elem = ' '
    character(len=24), pointer :: v_resu_elem(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    getResuElem = ' '
    resu_elem   = ' '
    enti_elem   = ' '
!
    if (present(vect_elem_)) then
        ASSERT(.not.present(matr_elem_))
        enti_elem = vect_elem_
    elseif (present(matr_elem_)) then
        ASSERT(.not.present(vect_elem_))
        enti_elem = matr_elem_
    endif
!
    if (enti_elem .ne. ' ') then
        call jeexin(enti_elem(1:19)//'.RELR', iret)
        if (iret .gt. 0) then
            call jeveuo(enti_elem(1:19)//'.RELR', 'L', vk24 = v_resu_elem)
            call jelira(enti_elem(1:19)//'.RELR', 'LONUTI', nb_resu)
            if (nb_resu .eq. 1) then
                resu_elem = v_resu_elem(1)(1:19)
            elseif (nb_resu .eq. 2) then
                resu_elem = v_resu_elem(1)(1:19)
                if (zerosd('RESUELEM', resu_elem)) then
                    resu_elem = v_resu_elem(2)(1:19)
                endif
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
    endif
!
    getResuElem = resu_elem
!
end function
