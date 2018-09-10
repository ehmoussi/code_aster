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
! aslint: disable=W1403
!
subroutine nonlinDSVectCombInit(ds_vectcomb)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
!
type(NL_DS_VectComb), intent(out) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Combination of vectors
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_vectcomb      : datastructure for combination of vectors
!
! --------------------------------------------------------------------------------------------------
!
    ds_vectcomb%nb_vect      = 0
    ds_vectcomb%vect_coef(:) = r8vide()
    ds_vectcomb%vect_name(:) = ' '
!
end subroutine
