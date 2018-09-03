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
subroutine rrc_init_dual(mesh       , result_rom , field_name,&
                         nb_equa_dom, mode_empi  , grnode_int,&
                         v_equa_rid , nb_equa_rom,&
                         v_equa_int , nb_equa_int)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rsexch.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnom.h"
#include "asterfort/jeveuo.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/romSelectEquationFromNode.h"
#include "asterfort/romCreateNodeFromEquation.h"
!
character(len=8), intent(in) :: mesh, result_rom
character(len=24), intent(in) :: field_name, mode_empi
integer, intent(in) :: nb_equa_dom
character(len=24), intent(in) :: grnode_int
integer, pointer :: v_equa_rid(:)
integer, intent(out) :: nb_equa_rom
integer, pointer :: v_equa_int(:)
integer, intent(out) :: nb_equa_int
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Initializations for dual base
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  result_rom       : results from reduced model
! In  field_name       : name of field where empiric modes have been constructed (NOM_CHAM)
! In  nb_equa_dom      : total number of equations (for complete model)
! In  mode_empi        : representative primal empiric mode
! In  v_equa_rid       : pointer to the list of equations in RID
! ... for each equation on complete model
!   0    => equation is not in RID
!   <> 0 => equation is in RID and is the index of equation
! Out nb_equa_rom      : total number of equations in RID
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: field_rom
    integer, pointer  :: v_list_node(:) => null()
    integer :: noeq, nord, iret
    integer :: nb_list_node, nb_cmp_node, nb_node_grno
    integer :: i_node, i_cmp, i_equa
    integer, pointer  :: v_grno(:) => null()
    integer, pointer  :: v_int_dual(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_39')
    endif
!
! - Get representative solution from ROM model
!
    call rsexch(' ', result_rom, field_name, 1, field_rom, iret)
    if (iret .ne. 0) then
        call utmess('F', 'ROM7_25', sk = field_name)
    endif
    call jelira(field_rom(1:19)//'.VALE', 'LONMAX', nb_equa_rom)
!
! - Construct list of nodes belonging to RID from equations
!
    call romCreateNodeFromEquation(mesh       , field_rom   ,&
                                   v_list_node, nb_list_node, nb_cmp_node)
!
! - Create list of equations in RID
!
    AS_ALLOCATE(vi = v_equa_rid, size = nb_equa_dom)
    call romSelectEquationFromNode(nb_equa_dom, mode_empi, field_rom, v_list_node,&
                                   v_equa_rid)
!
! - Access to GROUP_NO at interface
!
    call jelira(jexnom(mesh//'.GROUPENO',grnode_int), 'LONUTI', nb_node_grno)
    call jeveuo(jexnom(mesh//'.GROUPENO',grnode_int), 'L'     , vi = v_grno)
!
! - Create list of equations at interface
!
    ASSERT(nb_cmp_node*nb_node_grno .le. nb_equa_dom)
    AS_ALLOCATE(vi = v_int_dual, size = nb_equa_dom)
    do i_node = 1, nb_node_grno
        do i_cmp = 1, nb_cmp_node
            v_int_dual(i_cmp+nb_cmp_node*(v_grno(i_node)-1)) = 1
        enddo
    enddo
    AS_ALLOCATE(vi = v_equa_int, size = nb_equa_dom)
    noeq = 0
    nord = 0
    do i_equa = 1, nb_equa_dom
        if (v_equa_rid(i_equa) .ne. 0) then
            nord = nord + 1
            if (v_int_dual(i_equa) .eq. 0) then
                noeq = noeq + 1
                v_equa_rid(i_equa) = noeq
                v_equa_int(nord)   = noeq
            else
                v_equa_rid(i_equa) = 0
            endif
        endif
    enddo
    nb_equa_int = nb_equa_rom - nb_node_grno*nb_cmp_node
!
! - Clean
!
    AS_DEALLOCATE(vi = v_list_node)
    AS_DEALLOCATE(vi = v_int_dual)
!
end subroutine
