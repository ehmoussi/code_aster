! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine romResultsGetInfo(result, fieldNamez, model_user, ds_result)
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
#include "asterfort/romFieldGetInfo.h"
!
character(len=8), intent(in)  :: result
character(len=*), intent(in) :: fieldNamez
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
! In  fieldName        : name of field where empiric modes have been constructed (NOM_CHAM)
! In  model_user       : model from user (if required)
! IO  ds_result        : results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nume_first
    integer :: nb_node
    character(len=8)  :: model, mesh
    character(len=24) :: fieldRefe, fieldName
!
! --------------------------------------------------------------------------------------------------
!
    fieldName = fieldNamez
    nb_node   = 0
    model     = ' '
    mesh      = ' '
    fieldRefe = '&&ROM_COMP.FIELD'
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
    call rsexch(' ', result, fieldName, nume_first, fieldRefe, iret)
    if (iret .ne. 0) then
        call utmess('F', 'ROM5_11', sk = fieldName)
    endif
    call dismoi('NOM_MAILLA', fieldRefe, 'CHAMP', repk = mesh)
!
! - Get number of nodes affected by model
!
    call modelNodeEF(model, nb_node)
!
! - Get informations from (reference) field
!
    call romFieldGetInfo(model, fieldName, fieldRefe, ds_result%field)
!
! - Save parameters in datastructures
!
    ds_result%name  = result
    ds_result%mesh  = mesh
    ds_result%model = model
!
end subroutine
