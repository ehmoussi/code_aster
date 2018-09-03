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

subroutine medome_once(result, v_list_store, nb_store, nume_user_,&
                       model_, cara_elem_  , chmate_ , list_load_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rslesd.h"
#include "asterfort/utmess.h"
!
!
    character(len=8), intent(in) :: result
    integer, pointer :: v_list_store(:)
    integer, intent(in) :: nb_store
    integer, optional, intent(in) :: nume_user_
    character(len=8), optional, intent(out) :: model_
    character(len=8), optional, intent(out) :: cara_elem_
    character(len=24), optional, intent(out) :: chmate_
    character(len=19), optional, intent(out) :: list_load_
!
! --------------------------------------------------------------------------------------------------
!
! Get datastructures in result and check unicity
!
! --------------------------------------------------------------------------------------------------
!
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_store, nume_store0, nume_store, iexcit
    character(len=8) :: model0, cara_elem0
    character(len=8) :: model, cara_elem
    character(len=24) :: chmate0, chmate
    character(len=19) :: list_load0, list_load
!
! --------------------------------------------------------------------------------------------------
!
    if (present(nume_user_)) then
        nume_store0 = nume_user_
    else
        nume_store0 = v_list_store(1)
    endif
!
! - Get reference datastructures
!
    call rslesd(result    , nume_store0, model0, chmate0, cara_elem0,&
                list_load0, iexcit)
    model     = model0
    chmate    = chmate0
    cara_elem = cara_elem0
    list_load = list_load0
!
! - Check unicity
!             
    do i_store = 2, nb_store
        nume_store = v_list_store(i_store)
        call rslesd(result   , nume_store, model, chmate, cara_elem,&
                    list_load, iexcit)
        if (present(model_)) then
            if (model .ne. model0) then
                call utmess('F', 'CALCCHAMP_23')
            endif
        endif
        if (present(list_load_)) then
            if ((list_load .ne. list_load0) .and. (iexcit .eq. 0)) then
                call utmess('F', 'CALCCHAMP_24')
            endif
        endif
    end do
!
! - Output
!
    if (present(model_)) then
        model_ = model
    endif
    if (present(chmate_)) then
        chmate_ = chmate
    endif
    if (present(cara_elem_)) then
        cara_elem_ = cara_elem
    endif
    if (present(list_load_)) then
        list_load_ = list_load
    endif
!
end subroutine
