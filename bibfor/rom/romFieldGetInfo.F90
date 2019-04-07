! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine romFieldGetInfo(model, field_name, field_refe, ds_field, l_chck_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/modelNodeEF.h"
#include "asterfort/romGetListComponents.h"
#include "asterfort/romFieldChck.h"
!
character(len=8), intent(in)        :: model
character(len=24), intent(in)       :: field_refe, field_name
type(ROM_DS_Field), intent(inout)   :: ds_field
aster_logical, optional, intent(in) :: l_chck_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get informations from field
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  field_name       : name of field (NOM_CHAM)
! In  field_refe       : field to analyse
! IO  ds_field         : datastructure for field
! In  l_chck           : flag to check components
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_equa = 0, nb_node = 0, nb_cmp = 0
    character(len=8)  :: mesh = ' '
    aster_logical :: l_lagr = ASTER_FALSE, l_chck
!
! --------------------------------------------------------------------------------------------------
!
    l_chck = ASTER_TRUE
    if (present(l_chck_)) then
        l_chck = l_chck_
    endif
!
! - Get main parameters
!
    call dismoi('NB_EQUA'     , field_refe, 'CHAM_NO' , repi = nb_equa)
    call dismoi('NOM_MAILLA'  , model, 'MODELE'  , repk = mesh)
!
! - Get number of nodes affected by model
!
    call modelNodeEF(model, nb_node)
!
! - Get list of components in field
!
    call romGetListComponents(field_refe          , nb_equa            ,&
                              ds_field%v_equa_type, ds_field%v_list_cmp,&
                              nb_cmp              , l_lagr)
!
! - Save informations
!
    ds_field%field_name  = field_name
    ds_field%field_refe  = field_refe
    ds_field%mesh        = mesh
    ds_field%model       = model
    ds_field%nb_equa     = nb_equa
    ds_field%nb_node     = nb_node
    ds_field%l_lagr      = l_lagr
    ds_field%nb_cmp      = nb_cmp
!
! - Check components in field
!
    if (l_chck) then
        call romFieldChck(ds_field)
    endif
!
end subroutine
