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
subroutine nonlinDSVectCombAddAny(vect_name_, vect_coef, ds_vectcomb)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
character(len=*), intent(in) :: vect_name_
real(kind=8), intent(in) :: vect_coef
type(NL_DS_VectComb), intent(inout) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Combination of vectors
!
! Add new vector in list to combine (any vect_asse)
!
! --------------------------------------------------------------------------------------------------
!
! In  vect_name        : to get field name by name
! In  vect_coef        : coefficient to combine vector
! IO  ds_vectcomb      : datastructure for combination of vectors
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: vect_name
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(ds_vectcomb%nb_vect .lt. 20)
    vect_name = vect_name_
    ds_vectcomb%nb_vect = ds_vectcomb%nb_vect + 1
    ds_vectcomb%vect_coef(ds_vectcomb%nb_vect) = vect_coef
    ds_vectcomb%vect_name(ds_vectcomb%nb_vect) = vect_name
!
end subroutine
