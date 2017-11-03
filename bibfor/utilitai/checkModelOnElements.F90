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
!
subroutine checkModelOnElements(modelz,&
                                nb_elem     , list_elem     ,&
                                nb_type_elem, list_type_elem,&
                                nb_found)
!
implicit none
!
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeveuo.h"
!
character(len=*), intent(in) :: modelz
integer, intent(in) :: nb_elem
integer, intent(in), pointer :: list_elem(:)
integer, intent(in) :: nb_type_elem
character(len=16), intent(in), pointer :: list_type_elem(:)
integer, intent(out) :: nb_found
!
! --------------------------------------------------------------------------------------------------
!
! Model
!
! Check if modelisation exists on list of elements
!
! --------------------------------------------------------------------------------------------------
!


!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_elem, nume_elem, type_elem_nume
    integer :: i_type_elem
    character(len=8) :: model
    character(len=16) :: type_elem_name
    integer, pointer :: v_type_elem(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    model    = modelz
    nb_found = 0
!
! - Access to list of elements
!
    call jeveuo(model//'.MAILLE', 'E', vi=v_type_elem)
!
! - Count
!
    do i_elem = 1, nb_elem
        nume_elem      = list_elem(i_elem)
        type_elem_nume = v_type_elem(i_elem)
        if (type_elem_nume .ne. 0) then
            do i_type_elem = 1, nb_type_elem
                call jenuno(jexnum('&CATA.TE.NOMTE', type_elem_nume), type_elem_name)
                if (type_elem_name .eq. list_type_elem(i_type_elem)) then
                    nb_found = nb_found + 1
                endif
            end do
        endif
    end do
!
end subroutine
