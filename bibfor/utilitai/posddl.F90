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

subroutine posddl(typesd  , resu, node_name, cmp_name, node_nume,&
                  dof_nume)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/select_dof.h"
!
!
    character(len=*), intent(in) :: typesd
    character(len=*), intent(in) :: resu
    character(len=*), intent(in) :: node_name
    character(len=*), intent(in) :: cmp_name
    integer, intent(out) :: node_nume
    integer, intent(out) :: dof_nume
!
! --------------------------------------------------------------------------------------------------
!
! Get dof and node index
!
! --------------------------------------------------------------------------------------------------
!
! In  typesd    : type of datastructure (chamno/nume_ddl)
! In  resu      : name of datastructure (chamno/nume_ddl)
! In  node_name : name of (physical) node to find 
! In  cmp_name  : name of component to find
! Out node_nume : index of node (in mesh)
!                 0 if node doesn't exist
! Out dof_nume  : index of dof
!                 0 if (node,cmp) doesn't exist
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cmp, nb_node
    character(len=8) :: mesh
    integer, pointer :: list_idx_dof(:) => null()
    integer, pointer :: list_node(:) => null()
    character(len=8), pointer :: list_cmp(:) => null()
!
! --------------------------------------------------------------------------------------------------
! 
    dof_nume = 0
    if (typesd .eq. 'NUME_DDL') then
        call dismoi('NOM_MAILLA', resu, 'NUME_DDL', repk=mesh)
    else if (typesd .eq. 'CHAM_NO') then
        call dismoi('NOM_MAILLA', resu, 'CHAM_NO', repk=mesh)
    else
        ASSERT(.false.)
    endif
    call jenonu(jexnom(mesh//'.NOMNOE', node_name), node_nume)
!
    if (node_nume .ne. 0) then
!
        nb_cmp = 1
!
! ----- Create list of components to ssek
!
        AS_ALLOCATE(vk8=list_cmp, size = nb_cmp)
        list_cmp(1) = cmp_name
!
! ----- Create list of results
!
        AS_ALLOCATE(vi=list_idx_dof, size = nb_cmp)
!
! ----- Create list of nodes
!
        nb_node = 1
        AS_ALLOCATE(vi=list_node, size = nb_node)
        list_node(1) = node_nume
!
! ----- Find specific dof
!
        if (typesd .eq. 'NUME_DDL') then
            call select_dof(list_idx_dof = list_idx_dof, &
                            nume_ddlz = resu, &
                            nb_nodez  = nb_node, list_nodez = list_node,&
                            nb_cmpz   = nb_cmp , list_cmpz  = list_cmp)
        else if (typesd .eq. 'CHAM_NO') then
            call select_dof(list_idx_dof = list_idx_dof,&
                            chamnoz   = resu,&
                            nb_nodez  = nb_node, list_nodez = list_node,&
                            nb_cmpz   = nb_cmp , list_cmpz  = list_cmp)
        else
            ASSERT(.false.)
        endif
        dof_nume = list_idx_dof(1)
!
        AS_DEALLOCATE(vi=list_idx_dof)
        AS_DEALLOCATE(vi=list_node)
        AS_DEALLOCATE(vk8=list_cmp)
!
    endif

end subroutine
