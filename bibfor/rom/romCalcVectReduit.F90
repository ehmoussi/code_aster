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
subroutine romCalcVectReduit(i_mode     , nb_equa    , nb_vect,&
                             l_vect_name, l_vect_type, l_vect_redu,&
                             mode_type  , vc_mode    , vr_mode)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mcmult.h"
#include "asterfort/mrmult.h"
#include "asterfort/romModeSave.h"
#include "asterfort/jeveuo.h"
#include "blas/zdotc.h"
#include "blas/ddot.h"
!
integer, intent(in) :: i_mode, nb_vect, nb_equa
character(len=8), intent(in) :: l_vect_name(:)
character(len=1), intent(in) :: l_vect_type(:)
character(len=24), intent(in) :: l_vect_redu(:)
character(len=1), intent(in) :: mode_type
complex(kind=8), pointer, optional :: vc_mode(:)
real(kind=8), pointer, optional :: vr_mode(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Compute reduced vector
!
! --------------------------------------------------------------------------------------------------
!
! In  i_mode           : mode nomber
! In  nb_vect          : number of elementary vector
! In  l_vect_name      : list of names of elementary vector
! In  l_vect_type      : list of types (R or C) of elementary vectors
! In  mode_type        : type of mode  (R or C) 
! In  vr_mode          : pointeur vers le mode réel
! In  vc_mode          : pointeur vers le mode complexe
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_vect, i_equa
    complex(kind=8), pointer :: vc_vect_redu(:) => null()
    real(kind=8), pointer :: vr_vect_redu(:) => null()
    real(kind=8), pointer :: jv_vect_r(:) => null()
    complex(kind=8), pointer :: jv_vect_c(:) => null()
    character(len=1) :: vect_type
    character(len=8) :: vect_name
!
! --------------------------------------------------------------------------------------------------
! 
    if (mode_type .eq. 'R') then
        do i_vect = 1, nb_vect
            call jeveuo(l_vect_redu(i_vect), 'E', vr = vr_vect_redu)
            vect_name = l_vect_name(i_vect)
            vect_type = l_vect_type(i_vect)
            if (vect_type .eq. 'R') then
                call jeveuo(vect_name(1:8)//'           .VALE', 'L', vr=jv_vect_r)
                vr_vect_redu(i_mode) = ddot(nb_equa, vr_mode, 1, jv_vect_r, 1)
            else
                ASSERT(ASTER_FALSE)
            end if
        end do
    else if (mode_type .eq. 'C') then
        do i_vect = 1, nb_vect
            call jeveuo(l_vect_redu(i_vect), 'E', vc = vc_vect_redu)
            vect_name = l_vect_name(i_vect)
            vect_type = l_vect_type(i_vect)
            if (vect_type .eq. 'R') then
                call jeveuo(vect_name(1:8)//'           .VALE', 'L', vr=jv_vect_r)
                do i_equa = 1, nb_equa
                    vc_vect_redu(i_mode) = vc_vect_redu(i_mode)+&
                        dcmplx(jv_vect_r(i_equa))*dconjg(vc_mode(i_equa)) 
                end do           
            else if (vect_type .eq. 'C') then
                call jeveuo(vect_name(1:8)//'           .VALE', 'L', vc=jv_vect_c)
                vc_vect_redu(i_mode) = zdotc(nb_equa, vc_mode, 1, jv_vect_c, 1)
            else
                ASSERT(ASTER_FALSE)
            endif
        end do
    else 
        ASSERT(ASTER_FALSE)
    end if 
!
end subroutine
