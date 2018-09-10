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
subroutine romBaseGetInfo(base, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
#include "asterfort/romModeParaRead.h"
#include "asterfort/rs_getfirst.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rsexch.h"
#include "asterfort/ltnotb.h"
#include "asterfort/jeexin.h"
#include "asterfort/romFieldGetInfo.h"
!
character(len=8), intent(in)     :: base
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get informations about empiric modes base
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nume_first, nume_pl, nb_snap, i_mode
    integer :: nb_mode = 0
    character(len=8)  :: model = ' ', axe_line = ' ', base_type = ' '
    character(len=24) :: surf_num = ' ', field_refe = ' ', field_name = ' '
    character(len=19) :: tabl_coor = ' '
    type(ROM_DS_Field) :: ds_field
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get name of COOR_REDUIT table
!
    call jeexin(base//'           .LTNT', iret)
    if (iret .ne. 0) then
        call ltnotb(base, 'COOR_REDUIT', tabl_coor, iret)
        ASSERT(iret .ne. 1)
    endif
!
! - Number of modes
!
    call rs_get_liststore(base, nb_mode)
!
! - Get main parameters in empiric base
!
    i_mode = 1
    call romModeParaRead(base  , i_mode     ,&
                         model_      = model,&
                         field_name_ = field_name, &
                         nume_slice_ = nume_pl,&
                         nb_snap_    = nb_snap)
    if (nume_pl .ne. 0) then
        base_type = 'LINEIQUE'
    endif
!
! - Get _representative_ field in empiric base
!
    call rs_getfirst(base, nume_first)
    field_refe = base(1:8)//'FIELD_REFE'
    call rsexch(' ', base, field_name, nume_first, field_refe, iret)
    ASSERT(iret.eq.0)
!
! - Get informations from field
!
    ds_field = ds_empi%ds_mode
    call romFieldGetInfo(model, field_name, field_refe, ds_field)
!
! - Save informations about empiric modes
!
    ds_empi%base      = base
    ds_empi%tabl_coor = tabl_coor
    ds_empi%ds_mode   = ds_field
    ds_empi%base_type = base_type
    ds_empi%axe_line  = axe_line
    ds_empi%surf_num  = surf_num
    ds_empi%nb_mode   = nb_mode
    ds_empi%nb_snap   = nb_snap
!
end subroutine
