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

subroutine gt_linoma(mesh,list_elem,nb_elem,list_node,nb_node)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jeveuo.h"
#include "asterfort/gmgnre.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
! aslint: disable=W1306
!
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: nb_elem
    integer, intent(in) :: list_elem(nb_elem)
    integer, pointer :: list_node(:)
    integer, intent(out) :: nb_node
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get list of nodes from untracked master elements
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  nb_elem_mast     : number of master elements on current zone
! In  list_elem_mast   : name of datastructure for list of master elements on current zone
! IO  elem_mast_flag   : flag to mark master elements already tracked
! Out nb_node_mast     : number of master nodes on current zone
! Out list_node_mast   : list of master nodes on current zone
!
! --------------------------------------------------------------------------------------------------
!
  integer, pointer :: list_node_aux(:) => null()
  integer, pointer :: litrav(:) => null()
  integer, pointer :: list_elem_aux(:) => null()
  integer          :: aux(nb_elem), nb_elem_aux, nbno, j_info
  integer          :: i_elem, indx_mini, elem_nume, elem_indx
  character(len =24)::klitrav, klist_elem_aux, klist_node_aux
!
! --------------------------------------------------------------------------------------------------
!
! - Initialisation
!   
    klitrav        = '&&OP070_klitrav'
    klist_elem_aux = '&&OP070_klist_elem_aux'
    klist_node_aux = '&&OP070_klist_node_aux'
    nb_elem_aux    = 0
    nb_node        = 0 
    indx_mini = minval(list_elem)
    call jeveuo(mesh//'.DIME', 'L', j_info)
    nbno = zi(j_info-1+1)
    AS_ALLOCATE(vi=litrav, size=nbno )
!
! - Get untracked elements    
!
   do i_elem=1,nb_elem
        elem_nume = list_elem(i_elem)
        elem_indx = elem_nume + 1 - indx_mini 
        nb_elem_aux      = nb_elem_aux + 1
        aux(nb_elem_aux) = elem_nume
    end do
    AS_ALLOCATE(vi=list_elem_aux, size=nb_elem_aux )
    list_elem_aux(:)=aux(1:nb_elem_aux)
    
    if (nb_elem_aux .gt. 0) then
!
! ----- Get list of nodes frome untracked elements
!    
        AS_ALLOCATE(vi=list_node_aux, size=9*nb_elem_aux )
        call gmgnre(mesh, nbno , litrav, list_elem_aux, nb_elem_aux,&
                   list_node_aux, nb_node, 'TOUS')
        AS_ALLOCATE(vi=list_node, size=nb_node )
        list_node(:)=list_node_aux(1:nb_node)
!
! ----- Print check
!
        !write(*,*)"LIST_AUX:",list_elem_aux(:)
        !write(*,*)"LIST:",list_elem(:)
        !write(*,*)"LIST_NO : ",list_node(:)
!
        AS_DEALLOCATE(vi=litrav)
        AS_DEALLOCATE(vi=list_node_aux)
    
    end if
    
    AS_DEALLOCATE(vi=list_elem_aux)
!
end subroutine    
