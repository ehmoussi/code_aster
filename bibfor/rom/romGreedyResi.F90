! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine romGreedyResi(ds_multipara, ds_algoGreedy,&
                         i_mode_until, i_mode_coef , i_coef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/romEvalCoef.h"
!
type(ROM_DS_MultiPara), intent(inout) :: ds_multipara
type(ROM_DS_AlgoGreedy), intent(in) :: ds_algoGreedy
integer, intent(in) :: i_mode_until, i_mode_coef, i_coef
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Compute residual for one coefficient
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! In  ds_algoGreedy    : datastructure for Greedy algorithm
! In  i_mode_until     : last mode until compute
! In  i_mode_coef      : index of mode to compute coefficients
! In  i_coef           : index of coefficient
!
! --------------------------------------------------------------------------------------------------
!    
    integer :: i_mode, i_matr, i_equa
    integer :: nb_mode, nb_coef, nb_matr, nb_equa
    aster_logical :: l_coef_cplx, l_coef_real
    real(kind=8) :: coef_r
    complex(kind=8) :: coef_c, coef_cplx
    complex(kind=8), pointer :: vc_coef_redu(:) => null()
    complex(kind=8), pointer :: vc_resi_vect(:) => null()
    complex(kind=8), pointer :: vc_vect_2mbr(:) => null()
    real(kind=8), pointer :: vr_coef_redu(:) => null()
    real(kind=8), pointer :: vr_resi_vect(:) => null()
    real(kind=8), pointer :: vr_vect_2mbr(:) => null()
    complex(kind=8), pointer :: vc_matr_mode(:) => null()
    real(kind=8), pointer :: vr_matr_mode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_matr        = ds_multipara%nb_matr
    nb_coef        = ds_multipara%nb_vari_coef
    nb_mode        = ds_algoGreedy%solveROM%syst_size
    nb_equa        = ds_algoGreedy%solveDOM%syst_size
!
! - Access to objects and copy seconde member contribution in residual
!
    if (ds_algoGreedy%solveROM%syst_2mbr_type .eq. 'R') then
        call jeveuo(ds_algoGreedy%coef_redu, 'L', vr = vr_coef_redu)
        call jeveuo(ds_algoGreedy%solveDOM%syst_2mbr(1:19)//'.VALE', 'L', vr = vr_vect_2mbr)
        call jeveuo(ds_algoGreedy%resi_vect(1:19)//'.VALE', 'E', vr = vr_resi_vect)
        vr_resi_vect(:) = vr_vect_2mbr(:)
    else if (ds_algoGreedy%solveROM%syst_2mbr_type .eq. 'C') then
        call jeveuo(ds_algoGreedy%coef_redu, 'L', vc = vc_coef_redu)
        call jeveuo(ds_algoGreedy%solveDOM%syst_2mbr(1:19)//'.VALE', 'L', vc = vc_vect_2mbr)
        call jeveuo(ds_algoGreedy%resi_vect(1:19)//'.VALE', 'E', vc = vc_resi_vect)
        vc_resi_vect(:) = vc_vect_2mbr(:)
    else
        ASSERT(ASTER_FALSE)
    endif
    ASSERT(i_mode_until .le. nb_mode)
    ASSERT(i_mode_coef  .le. nb_mode)
!
! - Evaluate coefficients
!
    call romEvalCoef(ds_multipara, l_init = .false._1,&
                     i_mode_coef_ = i_mode_coef, i_coef_ = i_coef)
!
! - Matrix contribution
!    
    if (ds_algoGreedy%solveROM%syst_2mbr_type .eq. 'R') then
        do i_mode = 1, i_mode_until
            do i_matr = 1, nb_matr
                l_coef_real = ds_multipara%matr_coef(i_matr)%l_real
                ASSERT(l_coef_real)
                coef_r = ds_multipara%matr_coef(i_matr)%coef_real(i_coef)
                call jeveuo(ds_multipara%prod_matr_mode(i_matr), 'L', vr = vr_matr_mode)
                do i_equa = 1, nb_equa
                    vr_resi_vect(i_equa) = vr_resi_vect(i_equa) -&
                                          vr_coef_redu(nb_coef*(i_mode-1)+i_coef)*&
                                          coef_r*vr_matr_mode(i_equa+(i_mode-1)*nb_equa)
                end do  
            end do
        end do
    else if (ds_algoGreedy%solveROM%syst_2mbr_type .eq. 'C') then
        do i_mode = 1, i_mode_until
            do i_matr = 1, nb_matr
                l_coef_cplx = ds_multipara%matr_coef(i_matr)%l_cplx
                l_coef_real = ds_multipara%matr_coef(i_matr)%l_real
                if (l_coef_cplx) then
                    coef_c    = ds_multipara%matr_coef(i_matr)%coef_cplx(i_coef)
                    coef_cplx = coef_c
                else
                    coef_r    = ds_multipara%matr_coef(i_matr)%coef_real(i_coef)
                    coef_cplx = dcmplx(coef_r)
                endif
                call jeveuo(ds_multipara%prod_matr_mode(i_matr), 'L', vc = vc_matr_mode)
                do i_equa = 1, nb_equa
                    vc_resi_vect(i_equa) = vc_resi_vect(i_equa) -&
                                          vc_coef_redu(nb_coef*(i_mode-1)+i_coef)*&
                                          coef_cplx*vc_matr_mode(i_equa+(i_mode-1)*nb_equa)
                end do  
            end do
        end do
     else 
        ASSERT(ASTER_FALSE)
     end if 
!
end subroutine
