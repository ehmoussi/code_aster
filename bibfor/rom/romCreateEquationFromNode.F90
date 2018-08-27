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
subroutine romCreateEquationFromNode(ds_mode, v_equa  , nume_dof    ,&
                                     grnode_, nb_node_, v_list_node_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnom.h"
#include "asterfort/select_dof.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Field), intent(in) :: ds_mode
integer, pointer :: v_equa(:)
character(len=24), intent(in) :: nume_dof
character(len=24), optional, intent(in) :: grnode_
integer, optional, intent(in) :: nb_node_
integer, pointer, optional :: v_list_node_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Prepare the list of equations from list of nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_mode          : datastructure for empiric mode
! In  nume_dof         : name of numbering (NUME_DDL)
! Out v_equa           : pointer to list of equations for nodes
!
! In  grnode           : name of GROUP_NO
!<or>
! In  nb_node          : number of nodes
! In  v_list_node      : list of nodes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_node, nb_equa, nb_cmp
    integer, pointer :: v_list_node(:) => null()
    character(len=8), pointer :: v_list_cmp(:) => null() 
    character(len=24) :: field_name = ' '
    character(len=8) :: mesh = ' '
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_8')
    endif
!
! - Get parameters
!
    mesh       = ds_mode%mesh
    field_name = ds_mode%field_name
!
! - Access to list of nodes
!
    if (present(grnode_)) then
        call jelira(jexnom(mesh//'.GROUPENO', grnode_), 'LONUTI', nb_node)
        call jeveuo(jexnom(mesh//'.GROUPENO', grnode_), 'E'     , vi = v_list_node)
    else
        nb_node     = nb_node_
    endif
!
! - Create list of equations
!
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi = nb_equa)
    AS_ALLOCATE(vi = v_equa, size = nb_equa)
!
! - List of components to search
!
    if (field_name .eq. 'TEMP') then
        nb_cmp        = 1
        AS_ALLOCATE(vk8 = v_list_cmp, size = nb_cmp)
        v_list_cmp(1) = 'TEMP'
    elseif (field_name .eq. 'DEPL') then
        nb_cmp        = 3
        AS_ALLOCATE(vk8 = v_list_cmp, size = nb_cmp)
        v_list_cmp(1) = 'DX'
        v_list_cmp(2) = 'DY'
        v_list_cmp(3) = 'DZ'
    else
        ASSERT(.false.)
    endif
!
! - Find index of equations
!
    if (present(v_list_node_)) then
        call select_dof(list_equa  = v_equa      , nume_ddlz = nume_dof, nb_nodez  = nb_node,&
                        list_nodez = v_list_node_, nb_cmpz   = nb_cmp  , list_cmpz = v_list_cmp)
    else
        call select_dof(list_equa  = v_equa     , nume_ddlz = nume_dof, nb_nodez  = nb_node,&
                        list_nodez = v_list_node, nb_cmpz   = nb_cmp  , list_cmpz = v_list_cmp)
    endif
!
! - Clean
!
    AS_DEALLOCATE(vk8 = v_list_cmp)
!
end subroutine

