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
! aslint: disable=W1003
!
subroutine modelNodeEF(modelz, nb_node, v_list_node)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=*), intent(in) :: modelz
integer, intent(out) :: nb_node
integer, pointer, intent(out) :: v_list_node(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model - Utility
!
! Extract list of nodes where dof was assigned in model
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! Out nb_node          : number of nodes where dof was assign for model
! Out v_list_node      : list of nodes where dof was assign for model
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbenc, nb_node_mesh, i_node, ient, idx
    character(len=8) :: nomgd, mesh, model
    character(len=16) :: phenom
    character(len=19) :: ligrmo
    integer, pointer :: v_prnm(:) => null()
    integer, pointer :: idx_node(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    model = modelz
    call dismoi('PHENOMENE'   , model , 'MODELE'   , repk=phenom)
    call dismoi('NOM_GD'      , phenom, 'PHENOMENE', repk=nomgd)
    call dismoi('NB_EC'       , nomgd , 'GRANDEUR' , repi=nbenc)
    call dismoi('NOM_LIGREL'  , model , 'MODELE'   , repk=ligrmo)
    call dismoi('NOM_MAILLA'  , model , 'MODELE'   , repk=mesh)
    call dismoi('NB_NO_MAILLA', mesh  , 'MAILLAGE' , repi=nb_node_mesh)
    call jeveuo(ligrmo//'.PRNM', 'L', vi=v_prnm)
!
! - Detect nodes with dof
!
    AS_ALLOCATE(vi=idx_node, size=nb_node_mesh)
    nb_node = 0
    do i_node = 1, nb_node_mesh
        do ient = 1, nbenc
            if (v_prnm(nbenc*(i_node-1)+ient) .ne. 0) then
                idx_node(i_node) = 1
                nb_node = nb_node+1
            endif
        end do
    end do
!
! - Create final list
!
    idx = 0
    allocate(v_list_node(nb_node))
    v_list_node(1:nb_node) = 0
    do i_node = 1, nb_node_mesh
        if (idx_node(i_node) .ne. 0) then
            idx = idx + 1
            ASSERT(idx .le. nb_node)
            v_list_node(idx) = i_node
        endif
    end do
!
    AS_DEALLOCATE(vi=idx_node)
!
end subroutine
