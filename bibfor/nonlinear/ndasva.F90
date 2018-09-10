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
subroutine ndasva(sddyna, hval_veasse, cnvady)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/ndynlo.h"
!
character(len=19), intent(in) :: sddyna, hval_veasse(*), cnvady
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Get undead Neumann loads for dynamic
!
! --------------------------------------------------------------------------------------------------
!
! In  sddyna           : datastructure for dynamic
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cnvady           : name of resultant nodal field
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_impe, l_ammo
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    l_impe = ndynlo(sddyna,'IMPE_ABSO')
    l_ammo = ndynlo(sddyna,'AMOR_MODAL')
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Undead dynamic forces
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNDYNA', -1.d0, ds_vectcomb)
    if (l_ammo) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNAMOD', -1.d0, ds_vectcomb)
    endif
    if (l_impe) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNIMPE', -1.d0, ds_vectcomb)
    endif
!
! - Combination
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnvady)
!
end subroutine
