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
subroutine romCreateNodeFromEquation(mesh        , field_rom   , v_list_node,&
                                     nb_list_node, nb_cmp_node_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
!
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: field_rom
integer, pointer, optional :: v_list_node(:)
integer, intent(out) :: nb_list_node
integer, optional, intent(out) :: nb_cmp_node_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Prepare the list of nodes from list of equations in RID
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  field_rom        : field from reduced model (on RID)
! In  v_list_node      : pointer to the list of nodes
! for each node in mesh
!   0    => not in RID
!   <> 0 => index of node
! Out nb_list_node     : length of v_list_node
! OUt nb_cmp_node      : number of components by node (except LAGRANGE ! )
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_node_mesh, nb_cmp, nb_equa, nb_cmp_node
    integer :: i_equa, i_node, i_cmp, nume_node
    character(len=19) :: prof_chno
    integer, pointer :: v_deeq(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_34')
    endif
!
! - Create object
!
    nb_list_node = 0
    call dismoi('NB_NO_MAILLA', mesh, 'MAILLAGE', repi=nb_node_mesh)
    AS_ALLOCATE(vi = v_list_node, size = nb_node_mesh)
    nb_list_node = nb_node_mesh
!
! - Access to numbering
!
    call dismoi('PROF_CHNO', field_rom, 'CHAM_NO', repk=prof_chno)
    call jelira(field_rom(1:19)//'.VALE', 'LONMAX', nb_equa)
    call jeveuo(prof_chno(1:19)//'.DEEQ', 'L', vi = v_deeq)
!
! - Look for nodes
!
    do i_equa = 1, nb_equa
        i_node  = v_deeq(2*(i_equa-1)+1)
        i_cmp   = v_deeq(2*(i_equa-1)+2)
! ----- Physical node
        if (i_node .gt. 0 .and. i_cmp .gt. 0) then
            v_list_node(i_node) = v_list_node(i_node) + 1
        endif
! ----- Non-Physical node (Lagrange)
        if (i_node .gt. 0 .and. i_cmp .lt. 0) then
            ASSERT(ASTER_FALSE)
        endif
! ----- Non-Physical node (Lagrange) - LIAISON_DDL
        if (i_node .eq. 0 .and. i_cmp .eq. 0) then
            ASSERT(ASTER_FALSE)
        endif
    end do
!
! - Check for constant number of components by node
!
    nb_cmp_node = 0
    do i_node = 1, nb_node_mesh
        if (nb_cmp_node .eq. 0) then
            nb_cmp_node = v_list_node(i_node)
        else
            nb_cmp = v_list_node(i_node)
            if (nb_cmp .ne. 0 .and. nb_cmp.ne. nb_cmp_node) then
                call utmess('F', 'ROM6_35')
            endif
        endif
    end do
!
! - Replace number by index
!
    do i_node = 1, nb_node_mesh
        nume_node = i_node
        if (v_list_node(i_node) .ne. 0) then
            v_list_node(i_node) = nume_node
        endif
    end do
    if (present(nb_cmp_node_)) then
        nb_cmp_node_ = nb_cmp_node
    endif
!
end subroutine
