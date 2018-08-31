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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romConvertEquaToNode(field_refe, list_length, v_list_equa, v_list_node)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utlisi.h"
#include "asterfort/dismoi.h"
!
character(len=24), intent(in) :: field_refe
integer, intent(in) :: list_length
integer, pointer :: v_list_equa(:)
integer, pointer :: v_list_node(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Main process
!
! Convert index of equation to index of node
!
! --------------------------------------------------------------------------------------------------
!
! In  field_refe       : reference field for numbering of equations
! In  list_length      : length of lists
! In  v_list_equa      : pointer to list with index of equations
! In  v_list_node      : pointer to list with index of nodes
!
! --------------------------------------------------------------------------------------------------
!
    integer, pointer :: v_deeq(:) => null()
    character(len=19) :: prchno
    integer :: i_list, i_equa, nume_node
!
! --------------------------------------------------------------------------------------------------
!
    call dismoi('PROF_CHNO', field_refe, 'CHAM_NO', repk=prchno)
    call jeveuo(prchno(1:19)//'.DEEQ', 'L', vi = v_deeq)
!
! - Convert
!
    do i_list = 1, list_length
        i_equa = v_list_equa(i_list)
        nume_node  = v_deeq(2*(i_equa-1)+1)
        v_list_node(i_list) = nume_node
    end do
!
end subroutine
