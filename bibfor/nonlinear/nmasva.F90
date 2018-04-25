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
subroutine nmasva(list_func_acti, hval_veasse, cnvado, sddyna_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
#include "asterfort/nonlinDSVectCombAddDyna.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/isfonc.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: hval_veasse(*), cnvado
character(len=19), optional, intent(in) :: sddyna_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Get undead Neumann loads and multi-step dynamic schemes forces
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cnvado           : name of resultant nodal field
! In  sddyna           : datastructure for dynamic
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: coeext, coeex2, coeint
    aster_logical :: l_dyna, l_mult_step, l_macr
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    l_dyna      = ASTER_FALSE
    l_mult_step = ASTER_FALSE
    if (present(sddyna_)) then
        l_mult_step = ndynlo(sddyna_,'MULTI_PAS')
        l_dyna      = ndynlo(sddyna_,'DYNAMIQUE')
    endif
    l_macr = isfonc(list_func_acti,'MACR_ELEM_STAT')
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Coefficients
!
    if (l_dyna) then
        coeext = ndynre(sddyna_, 'COEF_MPAS_FEXT_PREC')
        coeex2 = ndynre(sddyna_, 'COEF_MPAS_FEXT_COUR')
        coeint = ndynre(sddyna_, 'COEF_MPAS_FINT_PREC')
    else
        coeext = 1.d0
        coeex2 = 1.d0
        coeint = 1.d0
    endif
!
! - Undead Neumann forces
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNFSDO', coeex2, ds_vectcomb)
!
! - Multi-step dynamic schemes forces from previous time step
!
    if (l_mult_step) then
        call nonlinDSVectCombAddDyna(sddyna_, 'CNFSDO', coeext, ds_vectcomb)
        call nonlinDSVectCombAddDyna(sddyna_, 'CNFINT', -1.d0*coeint, ds_vectcomb)
        call nonlinDSVectCombAddDyna(sddyna_, 'CNELTC', -1.d0*coeint, ds_vectcomb)
        call nonlinDSVectCombAddDyna(sddyna_, 'CNELTF', -1.d0*coeint, ds_vectcomb)
        if (l_macr) then
            call nonlinDSVectCombAddDyna(sddyna_, 'CNSSTR', -1.d0*coeint, ds_vectcomb)
        endif
    endif
!
! - Combination
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnvado)
!
end subroutine
