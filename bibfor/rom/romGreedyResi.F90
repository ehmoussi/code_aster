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

subroutine romGreedyResi(ds_empi, ds_para_rb, i_mode_until, i_mode_coef, i_coef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/romEvalCoef.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Empi), intent(in) :: ds_empi
    type(ROM_DS_ParaDBR_RB), intent(inout) :: ds_para_rb
    integer, intent(in) :: i_mode_until
    integer, intent(in) :: i_mode_coef
    integer, intent(in) :: i_coef
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Compute residual for one coefficient
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! IO  ds_para_rb       : datastructure for parameters (RB)
! In  i_mode_until     : last mode until compute
! In  i_mode_coef      : index of mode to compute coefficients
! In  i_coef           : index of coefficient
!
! --------------------------------------------------------------------------------------------------
!    
    integer :: i_mode, i_matr, i_equa
    integer :: iret
    integer :: nb_mode, nb_coef, nb_matr, nb_equa
    aster_logical :: l_coef_cplx, l_coef_real
    real(kind=8) :: coef_r
    complex(kind=8) :: coef_c, coef_cplx
    character(len=1) :: nume_prod
    character(len=19) :: matr_vect
    character(len=24) :: field_iden
    character(len=8) :: base
    type(ROM_DS_MultiPara) :: ds_multipara
    complex(kind=8), pointer :: v_matr_vect(:) => null()
    complex(kind=8), pointer :: v_coef_redu(:) => null()
    complex(kind=8), pointer :: v_resi_vect(:) => null()
    complex(kind=8), pointer :: v_2mbr_init(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    ds_multipara   = ds_para_rb%multipara
    nb_matr        = ds_multipara%nb_matr
    nb_coef        = ds_multipara%nb_vari_coef
    nb_mode        = ds_para_rb%solveROM%syst_size
    nb_equa        = ds_para_rb%solveDOM%syst_size
    base           = ds_empi%base
!
! - Access to objects
!
    if (ds_para_rb%solveROM%syst_2mbr_type .eq. 'C') then
        call jeveuo(ds_para_rb%coef_redu, 'L', vc = v_coef_redu)
        call jeveuo(ds_para_rb%vect_2mbr_init(1:19)//'.VALE', 'L', vc = v_2mbr_init)
        call jeveuo(ds_para_rb%resi_vect(1:19)//'.VALE', 'E', vc = v_resi_vect)
    else
        ASSERT(.false.)
    endif
    ASSERT(i_mode_until .le. nb_mode)
    ASSERT(i_mode_coef .le. nb_mode)
!
! - Evaluate coefficients
!
    call romEvalCoef(ds_multipara, l_init = .false._1,&
                     i_mode_coef_ = i_mode_coef, i_coef_ = i_coef)
!
! - Initial residual
!
    v_resi_vect(:) = v_2mbr_init(:)
    do i_mode = 1, i_mode_until
        do i_matr = 1, nb_matr
! --------- Get cofficients
            l_coef_cplx = ds_multipara%matr_coef(i_matr)%l_cplx
            l_coef_real = ds_multipara%matr_coef(i_matr)%l_real   
            if (l_coef_cplx) then
                coef_c    = ds_multipara%matr_coef(i_matr)%coef_cplx(i_coef)
                coef_cplx = coef_c
            else
                coef_r    = ds_multipara%matr_coef(i_matr)%coef_real(i_coef)
                coef_cplx = dcmplx(coef_r)
            endif
! --------- Read products [Matr]*{mode}
            write(nume_prod,'(I1)') i_matr
            field_iden = 'PROD_BASE_MATR_'//nume_prod
            call rsexch(' ', base, field_iden, i_mode, matr_vect, iret)
            call jeveuo(matr_vect(1:19)//'.VALE', 'L', vc = v_matr_vect)
! --------- Compute residual
            do i_equa = 1, nb_equa
                v_resi_vect(i_equa) = v_resi_vect(i_equa) -&
                                      v_coef_redu(nb_coef*(i_mode-1)+i_coef)*&
                                      coef_cplx*v_matr_vect(i_equa)
            end do  
        end do
    end do
!
end subroutine
