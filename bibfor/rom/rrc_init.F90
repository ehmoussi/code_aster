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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rrc_init(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbexve.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rrc_info.h"
#include "asterfort/dismoi.h"
#include "asterfort/rsexch.h"
#include "asterfort/jelira.h"
#include "asterfort/select_dof_3.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret
    character(len=24) :: typval, field_name
    integer :: nbval, nb_store
    integer :: nb_equa_dual, nb_cmp_dual, nb_equa_ridd
    integer :: nb_equa_prim, nb_cmp_prim, nb_equa_ridp
    integer :: nb_node_grno, i_cmp, i_node, i_eq, noeq = 0, nord = 0
    aster_logical :: l_prev_dual
    character(len=8) :: result_rom, mesh
    character(len=24) :: field
    integer, pointer  :: v_grno(:) => null()
    integer, pointer  :: v_int_dual(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_3')
    endif
!
! - Get parameters
!
    l_prev_dual  = ds_para%l_prev_dual
    result_rom   = ds_para%result_rom
    nb_equa_dual = ds_para%ds_empi_dual%nb_equa
    nb_cmp_dual  = ds_para%ds_empi_dual%nb_cmp
    nb_equa_prim = ds_para%ds_empi_prim%nb_equa
    nb_cmp_prim  = ds_para%ds_empi_prim%nb_cmp
    mesh         = ds_para%ds_empi_dual%mesh
!
! - Get table for reduced coordinates
!
    call ltnotb(ds_para%result_rom, 'COOR_REDUIT', ds_para%tabl_name, iret_ = iret)
    if (iret .gt. 0) then
        ds_para%tabl_name = ' '
    endif
!
! - Get reduced coordinates
!
    if (iret .eq. 0) then
        call tbexve(ds_para%tabl_name, 'COOR_REDUIT', ds_para%coor_redu, 'V', nbval, typval)
        ASSERT(typval .eq. 'R')
    endif
!
! - Type of result
!
    field_name = ds_para%ds_empi_prim%field_name
    if (field_name .eq. 'DEPL') then
        ds_para%type_resu = 'EVOL_NOLI'
    elseif (field_name .eq. 'TEMP') then
        ds_para%type_resu = 'EVOL_THER'
    else
        ASSERT(.false.)
    endif
!
! - Create output result datastructure
!
    call rs_get_liststore(ds_para%result_rom, nb_store)
    ds_para%nb_store = nb_store
    call rscrsd('G', ds_para%result_dom, ds_para%type_resu, nb_store)
!
! - Set models
!
    call dismoi('MODELE', ds_para%result_rom, 'RESULTAT', repk=ds_para%model_rom)
!
! - List of equations in RID (for primal)
!
    AS_ALLOCATE(vi = ds_para%v_equa_ridp, size = nb_equa_prim)
    call rsexch(' ', result_rom, ds_para%ds_empi_prim%field_name,&
                1, field, iret)
    call jelira(field(1:19)//'.VALE', 'LONMAX', nb_equa_ridp)
    call select_dof_3(field, nb_cmp_prim, ds_para%v_equa_ridp)
    ds_para%nb_equa_ridp = nb_equa_ridp
!
! - List of equations in RID (for dual)
!
    if (l_prev_dual) then
        AS_ALLOCATE(vi = ds_para%v_equa_ridd, size = nb_equa_dual)
        call rsexch(' ', result_rom, ds_para%ds_empi_dual%field_name,&
                    1, field, iret)
        call jelira(field(1:19)//'.VALE', 'LONMAX', nb_equa_ridd)
        call select_dof_3(field, nb_cmp_dual, ds_para%v_equa_ridd)
        ds_para%nb_equa_ridd = nb_equa_ridd
        AS_ALLOCATE(vi = ds_para%v_equa_ridi, size = nb_equa_ridd)
        call jelira(jexnom(mesh//'.GROUPENO',ds_para%grnode_int), 'LONUTI', nb_node_grno)
        call jeveuo(jexnom(mesh//'.GROUPENO',ds_para%grnode_int), 'L'     , vi = v_grno)
        AS_ALLOCATE(vi = v_int_dual, size = nb_equa_dual)
        do i_node = 1, nb_node_grno
            do i_cmp = 1, nb_cmp_dual
                v_int_dual(i_cmp+nb_cmp_dual*(v_grno(i_node)-1)) = 1
            enddo
        enddo
        do i_eq = 1, nb_equa_dual
            if (ds_para%v_equa_ridd(i_eq) .ne. 0) then
                nord = nord + 1
                if (v_int_dual(i_eq) .eq. 0) then
                    noeq = noeq + 1
                    ds_para%v_equa_ridd(i_eq) = noeq
                    ds_para%v_equa_ridi(nord) = noeq
                else
                    ds_para%v_equa_ridd(i_eq) = 0
                endif
            endif
        enddo
        ds_para%nb_equa_ridi = nb_equa_ridd - nb_node_grno*nb_cmp_dual
        AS_DEALLOCATE(vi = v_int_dual)
    endif
!
! - Print parameters
!
    if (niv .ge. 2) then
        call rrc_info(ds_para)
    endif
!
end subroutine
