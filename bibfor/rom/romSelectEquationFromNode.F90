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
subroutine romSelectEquationFromNode(nb_equa_dom, field_dom, field_rom, v_list_node,&
                                     v_equa)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jenuno.h"
#include "asterfort/nbec.h"
!
integer, intent(in) :: nb_equa_dom
character(len=24), intent(in) :: field_dom
character(len=24), intent(in) :: field_rom
integer, pointer :: v_list_node(:)
integer, pointer :: v_equa(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Prepare the list of equations in RID
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_equa_dom      : total number of equations (complete model)
! In  field_dom        : field (representative) of equations on complete model
! In  field_rom        : field (representative) of equations on reduced model
! In  v_list_node      : pointer to the list of nodes
! ... for each node in mesh
!   0    => node is not in RID
!   <> 0 => node is in RID and is the index of node
! In  v_equa           : list of equations in RID
! ... for each equation on complete model
!   0    => equation is not in RID
!   <> 0 => equation is in RID and is the index of equation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_ec
    integer :: i_equa, idx_gd, i_dof
    integer :: nume_node, nume_cmp, nume_equa
    character(len=19) :: prchno_dom, prchno_rom
    character(len=24) :: lili_name
    integer :: i_ligr_mesh
    integer, pointer :: v_deeq_dom(:) => null()
    integer, pointer :: v_nueq_rom(:) => null()
    integer, pointer :: v_prno_rom(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_37')
    endif
!
! - Access to complete numbering
!
    call dismoi('PROF_CHNO', field_dom, 'CHAM_NO', repk=prchno_dom)
    call jeveuo(prchno_dom(1:19)//'.DEEQ', 'L', vi = v_deeq_dom)
!
! - Get GRANDEUR informations
!
    idx_gd = 0
    nb_ec  = 0
    call dismoi('NUM_GD', field_rom, 'CHAM_NO', repi=idx_gd)
    ASSERT(idx_gd .ne. 0)
    nb_ec = nbec(idx_gd)
    ASSERT(nb_ec .le. 10)
!
! - Access to reduced numbering
!
    call dismoi('PROF_CHNO', field_rom, 'CHAM_NO', repk=prchno_rom)
    i_ligr_mesh = 1
    call jenuno(jexnum(prchno_rom(1:19)//'.LILI', i_ligr_mesh), lili_name)
    ASSERT(lili_name .eq. '&MAILLA')
    call jeveuo(jexnum(prchno_rom(1:19)//'.PRNO', i_ligr_mesh), 'L', vi = v_prno_rom)
    call jeveuo(prchno_rom(1:19)//'.NUEQ', 'L', vi = v_nueq_rom)
!
! - Select equations
!
    do i_equa = 1, nb_equa_dom
! ----- Get equation information in complete RID
        nume_node  = v_deeq_dom(2*(i_equa-1)+1)
        nume_cmp   = v_deeq_dom(2*(i_equa-1)+2)
! ----- Physical node
        if (nume_node .gt. 0 .and. nume_cmp .gt. 0) then
            if (v_list_node(nume_node) .eq. 0) then
! ------------- This node is NOT in RID
                v_equa(i_equa) = 0
            else
! ------------- This node is in RID
                i_dof       = v_prno_rom((nb_ec+2)*(nume_node-1)+1) - 1
! ------------- Index of equation
                nume_equa   = v_nueq_rom(i_dof+nume_cmp)
! ------------- Save index of equation in RID
                v_equa(i_equa) = nume_equa
            endif
        endif
! ----- Non-Physical node (Lagrange)
        if (nume_node .gt. 0 .and. nume_cmp .lt. 0) then
            ASSERT(ASTER_FALSE)
        endif
! ----- Non-Physical node (Lagrange) - LIAISON_DDL
        if (nume_node .eq. 0 .and. nume_cmp .eq. 0) then
            ASSERT(ASTER_FALSE)
        endif
    end do
!
end subroutine
