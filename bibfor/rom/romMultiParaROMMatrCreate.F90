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
subroutine romMultiParaROMMatrCreate(ds_empi  , ds_multipara, i_coef,&
                                     syst_matr)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "blas/zdotc.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
type(ROM_DS_MultiPara), intent(inout) :: ds_multipara
integer, intent(in) :: i_coef
character(len=19), intent(in) :: syst_matr
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create matrix for multiparametric problems (reduced problem)
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! IO  ds_multipara     : datastructure for multiparametric problems
! In  i_coef           : index of coefficient
! In  syst_matr        : name of matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_matr, nb_mode, nb_equa
    integer :: i_mode, i_matr, j_mode, iret
    character(len=24) :: field_iden
    character(len=8) :: base
    complex(kind=8) :: term
    aster_logical :: l_coef_cplx, l_coef_real
    real(kind=8) :: coef_r
    complex(kind=8) :: coef_c, coef_cplx
    character(len=1) :: nume_prod
    character(len=19) :: matr_vect, mode
    complex(kind=8), pointer :: v_mode(:) => null()
    complex(kind=8), pointer :: v_matr_vect(:) => null()
    complex(kind=8), pointer :: v_syst_matr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_67')
    endif
!
! - Initializations
!
    base           = ds_empi%base
    nb_mode        = ds_empi%nb_mode
    nb_equa        = ds_empi%ds_mode%nb_equa
    nb_matr        = ds_multipara%nb_matr
!
! - Compute matrix
!
    call jeveuo(syst_matr, 'E', vc = v_syst_matr)
    do i_mode = 1, nb_mode
        field_iden = 'DEPL'
        call rsexch(' ', base, field_iden, i_mode, mode, iret)
        call jeveuo(mode(1:19)//'.VALE', 'L', vc = v_mode)
        do j_mode = 1, nb_mode
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
                write(nume_prod,'(I1)') i_matr
                field_iden = 'PROD_BASE_MATR_'//nume_prod
                call rsexch(' ', base, field_iden, j_mode, matr_vect, iret)
                call jeveuo(matr_vect(1:19)//'.VALE', 'L', vc = v_matr_vect)
                term = zdotc(nb_equa, v_mode, 1, v_matr_vect, 1)
                v_syst_matr(nb_mode*(i_mode-1)+j_mode) = v_syst_matr(nb_mode*(i_mode-1)+j_mode)+&
                                                         term * coef_cplx
            end do
        end do 
    end do
!
end subroutine
