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

subroutine nurota(modelz, nume_ddl, compor, sdnuro)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/etenca.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/exisdg.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/nbelem.h"
#include "asterfort/nbgrel.h"
#include "asterfort/typele.h"
#include "asterfort/sele_elem_comp.h"
#include "asterfort/sele_node_elem.h"
#include "asterfort/select_dof.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: modelz
    character(len=24), intent(in) :: nume_ddl
    character(len=24), intent(in) :: compor
    character(len=24), intent(in) :: sdnuro
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm - Initializations
!
! Get position of large rotation dof 
!
! --------------------------------------------------------------------------------------------------
!
! In  modelz   : name of model
! In  nume_ddl : name of numbering (NUME_DDL)
! In  compor   : name of comportment CARTE
! In  sdnuro   : name of datastructure to save position of large rotation dof 
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_elem_type, nb_cmp, nb_node_found, nb_equa
    character(len=16) :: defo_comp
    character(len=8), pointer :: list_cmp(:) => null()
    integer, pointer :: list_equa(:) => null()
    integer, pointer :: list_node(:) => null()
    character(len=16), pointer :: list_elem_type(:) => null()
    integer, pointer :: list_elem_comp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Create list of elements type
!
    nb_elem_type = 3
    AS_ALLOCATE(vk16=list_elem_type, size = nb_elem_type)
    list_elem_type(1) = 'MECA_POU_D_T_GD'
    list_elem_type(2) = 'MEC3TR7H'
    list_elem_type(3) = 'MEC3QU9H'
!
! - Create list of components
!
    nb_cmp = 3
    AS_ALLOCATE(vk8=list_cmp, size = nb_cmp)
    list_cmp(1) = 'DRX'
    list_cmp(2) = 'DRY'
    list_cmp(3) = 'DRZ'
!
! - Pre-selection of elements which have GROT_GDEP
!
    defo_comp     = 'GROT_GDEP'
    call sele_elem_comp(modelz, compor, defo_comp, list_elem_comp)
!
! - Select nodes by element type
!
    call sele_node_elem(modelz        , nb_elem_type, list_elem_type, list_node, nb_node_found,&
                        list_elem_comp)
!
! - Create list of equations
!
    call dismoi('NB_EQUA', nume_ddl, 'NUME_DDL', repi=nb_equa)
    if (nb_node_found .gt. 0) then
        call wkvect(sdnuro, 'V V I', nb_equa, vi = list_equa)
    else
        goto 999
    endif
!
! - Find components in list of equations
!
    call select_dof(list_equa, &
                    nume_ddlz = nume_ddl,&
                    nb_nodez  = nb_node_found , list_nodez = list_node,&
                    nb_cmpz   = nb_cmp        , list_cmpz  = list_cmp)
!
999 continue
!
    AS_DEALLOCATE(vi=list_node)
    AS_DEALLOCATE(vi=list_elem_comp)
    AS_DEALLOCATE(vk8=list_cmp)
    AS_DEALLOCATE(vk16=list_elem_type)
end subroutine
