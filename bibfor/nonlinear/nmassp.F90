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
subroutine nmassp(ds_material   , list_func_acti,&
                  ds_algorom    , sddyna        ,&
                  ds_contact    , hval_veasse   ,&
                  cnpilo        , cndonn)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/ndassp.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nsassp.h"
#include "asterfort/vtzero.h"
!
type(NL_DS_Material), intent(in) :: ds_material
integer, intent(in) :: list_func_acti(*)
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
character(len=19), intent(in) :: sddyna
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: hval_veasse(*)
character(len=19), intent(in) :: cnpilo, cndonn
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Evaluate second member for prediction
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_material      : datastructure for material parameters
! In  list_func_acti   : list of active functionnalities
! In  ds_algorom       : datastructure for ROM parameters
! In  ds_contact       : datastructure for contact management
! In  sddyna           : datastructure for dynamic
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cndonn           : name of nodal field for "given" forces
! In  cnpilo           : name of nodal field for "pilotage" forces
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_stat, l_dyna
!
! --------------------------------------------------------------------------------------------------
!
    call vtzero(cnpilo)
    call vtzero(cndonn)
!
! - Active functionnalities
!
    l_stat = ndynlo(sddyna,'STATIQUE')
    l_dyna = ndynlo(sddyna,'DYNAMIQUE')
!
! - Evaluate second member for prediction
!
    if (l_dyna) then
        call ndassp(ds_material, list_func_acti, ds_contact,&
                    sddyna     , hval_veasse   , cndonn)
    else if (l_stat) then
        call nsassp(list_func_acti, ds_material, ds_contact, ds_algorom,&
                    hval_veasse   , cnpilo     , cndonn)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
