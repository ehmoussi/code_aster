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
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rrc_info.h"
#include "asterfort/dismoi.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/rrc_init_prim.h"
#include "asterfort/rrc_init_dual.h"
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
    integer :: nb_equa_dual, nb_equa_prim
    aster_logical :: l_prev_dual
    character(len=8) :: result_rom, mesh
    character(len=24) :: mode_prim, mode_dual
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
    mesh         = ds_para%ds_empi_prim%ds_mode%mesh
    nb_equa_prim = ds_para%ds_empi_prim%ds_mode%nb_equa
    mode_prim    = ds_para%ds_empi_prim%ds_mode%field_refe
    nb_equa_dual = ds_para%ds_empi_dual%ds_mode%nb_equa
    mode_dual    = ds_para%ds_empi_dual%ds_mode%field_refe
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
    field_name = ds_para%ds_empi_prim%ds_mode%field_name
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
! - Get model
!
    call dismoi('MODELE', ds_para%result_rom, 'RESULTAT', repk=ds_para%model_rom)
    if (ds_para%model_rom .eq. '#PLUSIEURS') then
        call utmess('F', 'ROM6_36')
    endif
!
! - Initializations for primal base
!
    call rrc_init_prim(mesh               , result_rom , field_name,&
                       nb_equa_prim       , mode_prim  ,&
                       ds_para%v_equa_ridp, ds_para%nb_equa_ridp)
!
! - Initializations for dual base
!
    if (l_prev_dual) then
        field_name = ds_para%ds_empi_dual%ds_mode%field_name
        call rrc_init_dual(mesh        , result_rom , field_name,&
                           nb_equa_dual, mode_dual  , ds_para%grnode_int,&
                           ds_para%v_equa_ridd, ds_para%nb_equa_ridd,&
                           ds_para%v_equa_ridi, ds_para%nb_equa_ridi)
    endif
!
! - Print parameters (debug)
!
    if (niv .ge. 2) then
        call rrc_info(ds_para)
    endif
!
end subroutine
