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

subroutine romModeProd(nb_matr  , l_matr_name, l_matr_type, prod_mode,&
                       mode_type, v_modec    , v_moder)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mcmult.h"
#include "asterfort/mrmult.h"
#include "asterfort/romModeSave.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_matr
    character(len=8), intent(in) :: l_matr_name(:)
    character(len=1), intent(in) :: l_matr_type(:)
    character(len=24), intent(in) :: prod_mode(:)
    character(len=1), intent(in) :: mode_type
    complex(kind=8), pointer, optional, intent(in) :: v_modec(:)
    real(kind=8), pointer, optional, intent(in) :: v_moder(:)
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
! In  v_moder          : pointeur vers le mode réel
! In  v_modec          : pointeur vers le mode complexe
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_matr
    complex(kind=8), pointer :: v_prodc(:) => null()
    real(kind=8), pointer :: v_prodr(:) => null()
    integer :: jv_desc_matr
    character(len=1) :: matr_type
    character(len=8) :: matr
!
! --------------------------------------------------------------------------------------------------
!
    do i_matr = 1, nb_matr
        matr      = l_matr_name(i_matr)
        matr_type = l_matr_type(i_matr)
        call jeveuo(matr(1:8)//'           .&INT', 'L', jv_desc_matr)
        if (matr_type .eq. 'C') then
            if (mode_type .eq. 'C') then
                call jeveuo(prod_mode(i_matr)(1:19)//'.VALE', 'L', vc = v_prodc)
                call mcmult('ZERO', jv_desc_matr, v_modec, v_prodc, 1, .true._1)
            elseif (mode_type .eq. 'R') then
                call jeveuo(prod_mode(i_matr)(1:19)//'.VALE', 'L', vr = v_prodr)
                call mrmult('ZERO', jv_desc_matr, v_moder, v_prodr, 1, .true._1)
            else
                ASSERT(.false.)
            endif
        elseif (matr_type .eq. 'R') then
            if (mode_type .eq. 'C') then
                call jeveuo(prod_mode(i_matr)(1:19)//'.VALE', 'L', vc = v_prodc)
                call mcmult('ZERO', jv_desc_matr, v_modec, v_prodc, 1, .true._1)
            elseif (mode_type .eq. 'R') then
                call jeveuo(prod_mode(i_matr)(1:19)//'.VALE', 'L', vr = v_prodr)
                call mrmult('ZERO', jv_desc_matr, v_moder, v_prodr, 1, .true._1)
            else
                ASSERT(.false.)
            endif
        endif
    end do
!
end subroutine
