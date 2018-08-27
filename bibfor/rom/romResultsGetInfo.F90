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
subroutine romResultsGetInfo(result, field_name, model_user, ds_result)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rsexch.h"
#include "asterfort/rs_getfirst.h"
#include "asterfort/dismoi.h"
#include "asterfort/modelNodeEF.h"
#include "asterfort/romBaseComponents.h"
!
character(len=8), intent(in)  :: result
character(len=16), intent(in) :: field_name
character(len=8), intent(in)  :: model_user
type(ROM_DS_Result), intent(inout) :: ds_result
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get informations about (non-linear) results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure (EVOL_*)
! In  field_name       : name of field where empiric modes have been constructed (NOM_CHAM)
! In  model_user       : model from user (if required)
! IO  ds_result        : results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nume_first
    integer :: nb_equa = 0, nb_node = 0
    character(len=8)  :: model = ' ', mesh = ' '
    character(len=24) :: field_refe = '&&ROM_COMP.FIELD'
    integer :: nb_cmp_by_node
    character(len=8) :: cmp_by_node(10)
    aster_logical :: l_lagr
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get information about model
!
    call dismoi('NOM_MODELE', result, 'RESULTAT', repk = model)
    if (model .eq. '#AUCUN' .or. model .eq. ' ') then
        if (model_user .eq. ' ') then
            call utmess('F', 'ROM5_54')
        else
            model = model_user
        endif
    endif
!
! - Get informations about fields
!
    call rs_getfirst(result, nume_first)
    call rsexch(' ', result, field_name, nume_first, field_refe, iret)
    if (iret .ne. 0) then
        call utmess('F', 'ROM5_11', sk = field_name)
    endif
    call dismoi('NB_EQUA'     , field_refe, 'CHAM_NO' , repi = nb_equa)
    call dismoi('NOM_MAILLA'  , field_refe, 'CHAM_NO' , repk = mesh)
!
! - Get components in fields
!
    call romBaseComponents(mesh          , nb_equa    ,&
                           field_name    , field_refe ,&
                           nb_cmp_by_node, cmp_by_node, l_lagr)
!
! - Get number of nodes affected by model
!
    call modelNodeEF(model, nb_node)
!
! - Save parameters in datastructures
!
    ds_result%name           = result
    ds_result%mesh           = mesh
    ds_result%model          = model
    ds_result%field_name     = field_name
    ds_result%field_refe     = field_refe
    ds_result%l_lagr         = l_lagr
    ds_result%nb_cmp_by_node = nb_cmp_by_node
    ds_result%cmp_by_node    = cmp_by_node
    ds_result%nb_node        = nb_node
!
end subroutine
