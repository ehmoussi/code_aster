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

subroutine nmext2(mesh         , field    , nb_cmp  , nb_node  , type_extr,&
                  type_extr_cmp, list_node, list_cmp, work_node)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/nmexti.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: nb_node
    integer, intent(in) :: nb_cmp
    character(len=8), intent(in) :: type_extr
    character(len=8), intent(in) :: type_extr_cmp
    character(len=24), intent(in) :: list_node
    character(len=24), intent(in) :: list_cmp
    character(len=19), intent(in) :: field
    character(len=19), intent(in) :: work_node
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Field extraction datastructure
!
! Extract value(s) at nodes and store them in working vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  field            : name of field
! In  nb_node          : number of nodes
! In  nb_cmp           : number of components
! In  work_node        : working vector to save node values
! In  list_node        : name of object contains list of nodes
! In  list_cmp         : name of object contains list of components
! In  type_extr        : type of extraction
! In  type_extr_cmp    : type of extraction for components
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_para_maxi
    parameter    (nb_para_maxi=20)
    real(kind=8) :: vale_resu(nb_para_maxi)
!
    integer :: i_node, i_node_work, node_nume
    character(len=8) :: node_name
    integer :: i_vale, nb_vale
    real(kind=8) :: valr, val2r
    real(kind=8), pointer :: v_work_node(:) => null()
    integer, pointer :: v_list_node(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jeveuo(work_node, 'E', vr = v_work_node)
    ASSERT(nb_cmp.le.nb_para_maxi)
!
! - List of nodes
!
    call jeveuo(list_node, 'L', vi = v_list_node)
!
! - Loop on nodes
!
    do i_node = 1, nb_node
!
! ----- Current node
!
        node_nume = v_list_node(i_node)
        call jenuno(jexnum(mesh(1:8)//'.NOMNOE', node_nume), node_name)
!
! ----- Extract value(s) at node
!
        call nmexti(node_name, field    , nb_cmp, list_cmp, type_extr_cmp,&
                    nb_vale   , vale_resu)
!
! ----- Select index in working vector
!
        if (type_extr .eq. 'VALE') then
            i_node_work = i_node
        else
            i_node_work = 1
        endif
!
! ----- Save values in working vector
!
        do i_vale = 1, nb_vale
            valr  = v_work_node(i_vale+nb_cmp*(i_node_work-1))
            val2r = vale_resu(i_vale)
            if (type_extr .eq. 'VALE') then
                v_work_node(i_vale+nb_cmp*(i_node_work-1)) = val2r
            else if (type_extr.eq.'MIN') then
                v_work_node(i_vale+nb_cmp*(i_node_work-1)) = min(val2r,valr)
            else if (type_extr.eq.'MAX') then
                v_work_node(i_vale+nb_cmp*(i_node_work-1)) = max(val2r,valr)
            else if (type_extr.eq.'MAXI_ABS') then
                v_work_node(i_vale+nb_cmp*(i_node_work-1)) = max(abs(val2r), abs(valr))
            else if (type_extr.eq.'MINI_ABS') then
                v_work_node(i_vale+nb_cmp*(i_node_work-1)) = min(abs(val2r), abs(valr))
            else if (type_extr.eq.'MOY') then
                v_work_node(i_vale+nb_cmp*(i_node_work-1)) = valr+val2r
            else
                ASSERT(.false.)
            endif
        end do
    end do
!
! - For mean value
!
    if (type_extr .eq. 'MOY') then
        i_node_work = 1
        do i_vale = 1, nb_vale
            valr = v_work_node(i_vale+nb_cmp*(i_node_work-1))
            if (nb_node .ne. 0) then
                v_work_node(i_vale+nb_cmp*(i_node_work-1)) = valr/nb_node
            endif
        end do
    endif
!
end subroutine
