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
subroutine nonlinIntegratePrepare(list_func_acti , sddyna, model,&
                                  ds_constitutive)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/comp_info.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna
character(len=8), intent(in) :: model
type(NL_DS_Constitutive), intent(inout) :: ds_constitutive
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Constitutive laws
!
! Prepare integration of constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : dynamic parameters datastructure
! In  model            : name of model
! IO  ds_constitutive  : datastructure for constitutive laws management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_implex, l_resi_comp, l_stat, l_dyna
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_28')
    endif
!
! - Active functionnalities
!
    l_implex    = isfonc(list_func_acti,'IMPLEX')
    l_resi_comp = isfonc(list_func_acti,'RESI_COMP')
    l_stat      = ndynlo(sddyna,'STATIQUE')
    l_dyna      = ndynlo(sddyna,'DYNAMIQUE')
!
! - Activation
!
    if (l_resi_comp) then
        ds_constitutive%l_pred_cnfnod = ASTER_TRUE
    endif
    if (l_implex) then
        ds_constitutive%l_pred_cnfnod = ASTER_TRUE
    endif
    if (l_stat) then
        ds_constitutive%l_pred_cnfnod = ASTER_TRUE
    endif
    if (l_dyna) then
        ds_constitutive%l_pred_cnfint = ASTER_TRUE
    endif
!
    if (niv .ge. 2) then
        call comp_info(model, ds_constitutive%compor)
    endif
!
end subroutine
