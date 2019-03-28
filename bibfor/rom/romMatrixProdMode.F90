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

subroutine romMatrixProdMode(nb_matr  , l_matr_name, l_matr_type, matr_mode_curr,&
                             prod_matr_mode, i_mode, mode_type, vc_mode, vr_mode)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/mcmult.h"
#include "asterfort/mrmult.h"
#include "asterfort/romModeSave.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_matr, i_mode
    character(len=8), intent(in) :: l_matr_name(:)
    character(len=1), intent(in) :: l_matr_type(:)
    character(len=19), intent(in) :: matr_mode_curr(:)
    character(len=24), intent(in) :: prod_matr_mode(:)
    character(len=1), intent(in) :: mode_type
    complex(kind=8), pointer, optional :: vc_mode(:)
    real(kind=8), pointer, optional :: vr_mode(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Compute products matrix x mode
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_matr          : number of elementary matrixes
! In  l_matr_name      : list of names of elementary matrixes
! In  l_matr_type      : list of types (R or C) of elementary matrixes
! In  mode_type        : type of mode  (R or C) 
! In  vr_mode          : pointeur vers le mode réel
! In  vc_mode          : pointeur vers le mode complexe
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_matr, i_equa, nb_equa
    complex(kind=8), pointer :: vc_matr_mode_c(:) => null()
    complex(kind=8), pointer :: vc_matr_mode(:) => null()
    real(kind=8), pointer :: vr_matr_mode_c(:) => null()
    real(kind=8), pointer :: vr_matr_mode(:) => null()
    integer :: jv_desc_matr
    character(len=1) :: matr_type
    character(len=8) :: matr
!
! --------------------------------------------------------------------------------------------------
!
    call dismoi('NB_EQUA' , l_matr_name(1), 'MATR_ASSE', repi = nb_equa)

    do i_matr = 1, nb_matr
        matr      = l_matr_name(i_matr)
        matr_type = l_matr_type(i_matr)
        call jeveuo(matr(1:8)//'           .&INT', 'L', jv_desc_matr)
        if (matr_type .eq. 'C') then
            if (mode_type .eq. 'C') then
                call jeveuo(matr_mode_curr(i_matr)(1:19)//'.VALE', 'L', &
                            vc = vc_matr_mode_c)
                call mcmult('ZERO', jv_desc_matr, vc_mode, vc_matr_mode_c, 1, .true._1)
                call jeveuo(prod_matr_mode(i_matr), 'E', vc = vc_matr_mode)
                do i_equa = 1, nb_equa 
                   vc_matr_mode((i_mode-1)*nb_equa+i_equa) = vc_matr_mode_c(i_equa)
                end do
            else
                ASSERT(.false.)
            endif
        elseif (matr_type .eq. 'R') then
            if (mode_type .eq. 'C') then
                call jeveuo(matr_mode_curr(i_matr)(1:19)//'.VALE', 'L',&
                            vc = vc_matr_mode_c)
                call mcmult('ZERO', jv_desc_matr, vc_mode, vc_matr_mode_c, 1, .true._1)
                call jeveuo(prod_matr_mode(i_matr), 'E', vc = vc_matr_mode)
                do i_equa = 1, nb_equa 
                   vc_matr_mode((i_mode-1)*nb_equa+i_equa) = vc_matr_mode_c(i_equa)
                end do
            elseif (mode_type .eq. 'R') then
                call jeveuo(matr_mode_curr(i_matr)(1:19)//'.VALE', 'L',&
                            vr = vr_matr_mode_c)
                call mrmult('ZERO', jv_desc_matr, vr_mode, vr_matr_mode_c, 1, .true._1)
                call jeveuo(prod_matr_mode(i_matr), 'E', vr = vr_matr_mode)
                do i_equa = 1, nb_equa 
                   vr_matr_mode((i_mode-1)*nb_equa+i_equa) = vr_matr_mode_c(i_equa)
                end do
            else
                ASSERT(.false.)
            endif
        endif
    end do
!
end subroutine
