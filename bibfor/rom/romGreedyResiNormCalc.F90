! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine romGreedyResiNormCalc(i_coef, nb_equa, ds_algoGreedy)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "blas/zdotc.h"
#include "blas/ddot.h"
#include "asterfort/jeveuo.h"
!
integer, intent(in) :: i_coef, nb_equa
type(ROM_DS_AlgoGreedy), intent(inout) :: ds_algoGreedy
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Normalization of residual
!
! --------------------------------------------------------------------------------------------------
!
! In  i_coef           : index of coefficient
! In  nb_equa          : number of equations
! IO  ds_algoGreedy    : datastructure for Greedy algorithm
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8), pointer :: vc_resi_vect(:) => null()
    real(kind=8), pointer :: vr_resi_vect(:) => null()
    complex(kind=8), pointer :: vc_vect_2mbr(:) => null()
    real(kind=8), pointer :: vr_vect_2mbr(:) => null()
    complex(kind=8) :: normc_2mbr, normc_resi
    real(kind=8) :: normr_2mbr, normr_resi
    character(len=1) :: resi_type
!
! --------------------------------------------------------------------------------------------------
!
    resi_type = ds_algoGreedy%resi_type
!
! - Compute norm of residual / norm of second member
!
    if (resi_type .eq. 'R') then
        call jeveuo(ds_algoGreedy%solveDOM%syst_2mbr(1:19)//'.VALE', 'L', vr = vr_vect_2mbr)
        call jeveuo(ds_algoGreedy%resi_vect(1:19)//'.VALE', 'L', vr = vr_resi_vect)
        normr_2mbr = ddot(nb_equa, vr_vect_2mbr, 1, vr_vect_2mbr, 1)
        normr_resi = ddot(nb_equa, vr_resi_vect, 1, vr_resi_vect, 1)
        ds_algoGreedy%resi_norm(i_coef) = sqrt(normr_resi/normr_2mbr)
    else if (resi_type .eq. 'C') then
        call jeveuo(ds_algoGreedy%solveDOM%syst_2mbr(1:19)//'.VALE', 'L', vc = vc_vect_2mbr)
        call jeveuo(ds_algoGreedy%resi_vect(1:19)//'.VALE', 'L', vc = vc_resi_vect)
        normc_2mbr = zdotc(nb_equa, vc_vect_2mbr, 1, vc_vect_2mbr, 1)
        normc_resi = zdotc(nb_equa, vc_resi_vect, 1, vc_resi_vect, 1)
        ds_algoGreedy%resi_norm(i_coef) = real(sqrt(real(normc_resi/normc_2mbr)))
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
