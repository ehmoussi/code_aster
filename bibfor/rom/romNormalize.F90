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

subroutine romNormalize(vect_type, vect_vale, nb_equa)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "blas/zdotc.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=1), intent(in) :: vect_type
    character(len=19), intent(in) :: vect_vale
    integer, intent(in) :: nb_equa
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Normalization of vector
!
! --------------------------------------------------------------------------------------------------
!
! In  vect_type        : type of vector (real or complex)
! In  vect_vale        : name of vector to normalize
! In  nb_equa          : number of equations
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8), pointer :: v_valec(:) => null()
    complex(kind=8) :: normc
!
! --------------------------------------------------------------------------------------------------
!
    if (vect_type .eq. 'C') then
        call jeveuo(vect_vale(1:19)//'.VALE', 'E', vc = v_valec)
        normc = zdotc(nb_equa, v_valec, 1, v_valec, 1)
        v_valec(1:nb_equa) = v_valec(1:nb_equa) / normc
    else
        ASSERT(.false.)
    endif
!
end subroutine
