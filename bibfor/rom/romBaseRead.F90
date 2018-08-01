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
subroutine romBaseRead(base, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/jeexin.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
#include "asterfort/romBaseInfo.h"
#include "asterfort/romModeParaRead.h"
#include "asterfort/rs_getfirst.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rsexch.h"
#include "asterfort/modelNodeEF.h"
#include "asterfort/romBaseComponents.h"
!
character(len=8), intent(in)     :: base
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Read empiric modes base
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret, nume_first, nume_pl, nb_snap, i_mode
    integer :: nb_equa = 0, nb_mode = 0, nb_node = 0, nb_cmp_by_node = 0
    character(len=8)  :: mesh = ' ', model = ' ', axe_line = ' ', base_type = ' '
    character(len=8)  :: cmp_by_node(10) = ' '
    character(len=24) :: surf_num = ' ', field_refe = ' ', field_name = ' '
    aster_logical :: l_lagr = ASTER_FALSE
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_2')
    endif
!
! - Get informations about empiric modes - Parameters
!
    call rs_get_liststore(base, nb_mode)
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
! - Get informations about empiric modes - Field
!
    call rs_getfirst(base, nume_first)
    field_refe = base(1:8)//'FIELD_REFE'
    call rsexch(' ', base, field_name, nume_first, field_refe, iret)
    ASSERT(iret.eq.0)
!
! - Get informations about empiric modes - Others
!
    call dismoi('NB_EQUA'     , field_refe, 'CHAM_NO' , repi = nb_equa)
    call dismoi('NOM_MAILLA'  , model     , 'MODELE'  , repk = mesh)
!
! - Get number of nodes affected by model
!
    call modelNodeEF(model, nb_node)
!
! - Get components in empiric modes
!
    call romBaseComponents(mesh          , nb_equa    ,&
                           field_name    , field_refe ,&
                           nb_cmp_by_node, cmp_by_node, l_lagr)
!
! - Save informations about empiric modes
!
    ds_empi%base           = base
    ds_empi%field_name     = field_name
    ds_empi%field_refe     = field_refe
    ds_empi%mesh           = mesh
    ds_empi%model          = model
    ds_empi%base_type      = base_type
    ds_empi%axe_line       = axe_line
    ds_empi%surf_num       = surf_num
    ds_empi%nb_equa        = nb_equa
    ds_empi%nb_node        = nb_node
    ds_empi%nb_mode        = nb_mode
    ds_empi%nb_snap        = nb_snap
    ds_empi%l_lagr         = l_lagr
    ds_empi%nb_cmp_by_node = nb_cmp_by_node
    ds_empi%cmp_by_node    = cmp_by_node
!
! - Print
!
    if (niv .ge. 2) then
       call romBaseInfo(ds_empi)
    endif
!
end subroutine
