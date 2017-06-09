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
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rrc_info.h"
#include "asterfort/dismoi.h"
!
! person_in_charge: mickael.abbas at edf.fr
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
    integer :: nbval, nb_store, nb_mode
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_3')
    endif
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
    nb_mode              = ds_para%ds_empi_prim%nb_mode
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
! - Print parameters
!
    if (niv .ge. 2) then
        call rrc_info(ds_para)
    endif
!
end subroutine
