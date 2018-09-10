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
subroutine nmacva(hval_veasse, cnvado)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/nmchex.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
#include "asterfort/nonlinDSVectCombInit.h"
!
character(len=19), intent(in) :: hval_veasse(*), cnvado
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Get undead Neumann loads
!
! --------------------------------------------------------------------------------------------------
!
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cnvado           : name of resultant nodal field
!
! --------------------------------------------------------------------------------------------------
!
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Dead Neumann forces
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNFSDO', 1.d0, ds_vectcomb)
!
! - Combination
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnvado)
!
end subroutine
