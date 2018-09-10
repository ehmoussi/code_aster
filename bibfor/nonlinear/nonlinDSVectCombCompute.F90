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
subroutine nonlinDSVectCombCompute(ds_vectcomb, vect_resu)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
type(NL_DS_VectComb), intent(in) :: ds_vectcomb
character(len=19), intent(in) :: vect_resu
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Combination of vectors
!
! Combine all vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_vectcomb      : datastructure for combination of vectors
! In  vect_resu        : name of result vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_vect
!
! --------------------------------------------------------------------------------------------------
!
    call vtzero(vect_resu)
    do i_vect = 1, ds_vectcomb%nb_vect
        call vtaxpy(ds_vectcomb%vect_coef(i_vect), ds_vectcomb%vect_name(i_vect), vect_resu)
    end do
!
end subroutine
