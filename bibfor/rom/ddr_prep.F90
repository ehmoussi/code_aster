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

subroutine ddr_prep(ds_para, v_list_prim, v_list_dual, v_list_rid, nb_node_rid)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utlisi.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_ParaDDR), intent(in) :: ds_para
    integer, intent(in), pointer :: v_list_prim(:)
    integer, intent(in), pointer :: v_list_dual(:)
    integer, intent(out), pointer :: v_list_rid(:)
    integer, intent(out) :: nb_node_rid
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Main process
!
! Prepare list of nodes in RID
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters of EIM computation
! In  v_list_prim      : list of 'magic" points for primal base
! In  v_list_dual      : list of 'magic" points for dual base
! Out v_list_rid       : list of nodes in RID (absolute number from mesh)
! Out nb_node_rid      : number of nodes in RID
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_mode_prim, nb_mode_dual, nb_mode_total
    integer :: nb_cmp_prim, nb_cmp_dual, nb_rid_mini
    integer :: i_node_rid
    integer, pointer :: v_list_unio1(:) => null()
    integer, pointer :: v_list_unio2(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Initializations
!
    nb_node_rid   = 0
!
! - Get parameters
!
    nb_mode_prim  = ds_para%ds_empi_prim%nb_mode
    nb_mode_dual  = ds_para%ds_empi_dual%nb_mode
    nb_mode_total = nb_mode_prim + nb_mode_dual
    nb_cmp_prim   = ds_para%ds_empi_prim%nb_cmp
    nb_cmp_dual   = ds_para%ds_empi_dual%nb_cmp
    nb_rid_mini   = ds_para%nb_rid_mini
!
! - Prepare working objects
!
    AS_ALLOCATE(vi = v_list_unio1, size = nb_mode_total)
    AS_ALLOCATE(vi = v_list_unio2, size = nb_mode_total+nb_rid_mini)
!
! - "convert" magic points to nodes
!    
    if (nb_cmp_prim .ne. 1) then
        v_list_prim = v_list_prim/nb_cmp_prim + 1
    endif
    v_list_dual = (v_list_dual-1)/nb_cmp_dual + 1
!
! - Assembling the two lists to find a list of interpolated points
!
    call utlisi('UNION'     ,&
                v_list_prim , nb_mode_prim ,&
                v_list_dual , nb_mode_dual ,&
                v_list_unio1, nb_mode_total, nb_node_rid)
!
! - Assembling the two lists to find a list of interpolated points
!
    if (nb_rid_mini .gt. 0) then
        call utlisi('UNION'     ,&
                    v_list_unio1      , nb_node_rid ,&
                    ds_para%v_rid_mini, nb_rid_mini,&
                    v_list_unio2      , nb_mode_total+nb_rid_mini, nb_node_rid)
    endif
!
! - List of nodes in RID
!
    AS_ALLOCATE(vi = v_list_rid , size = nb_node_rid)
    do i_node_rid = 1, nb_node_rid
        if (nb_rid_mini .eq. 0) then
            v_list_rid(i_node_rid) = v_list_unio1(i_node_rid)
        else
            v_list_rid(i_node_rid) = v_list_unio2(i_node_rid)
        endif
    enddo
    if (niv .ge. 2) then
        call utmess('I', 'ROM4_25', si = nb_node_rid)
    endif
!
! - Clean
!
    AS_DEALLOCATE(vi=v_list_unio1)
    AS_DEALLOCATE(vi=v_list_unio2)
!
end subroutine
