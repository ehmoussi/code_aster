! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine romEvalCoefDSInit(ds_evalcoef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_EvalCoef), intent(out) :: ds_evalcoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialisation of datastructure for multiparametric problems - Evaluation
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_evalcoef      : datastructure for multiparametric problems - Evaluation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_82')
    endif
!
    ds_evalcoef%nb_para      = 0
    ds_evalcoef%para_name(:) = ' '
    ds_evalcoef%para_vale(:) = 0.d0
!
end subroutine
