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
subroutine romMultiParaROM2mbrCreate(ds_empi, ds_multipara, i_coef, syst_2mbrROM)
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
character(len=19), intent(in) :: syst_2mbrROM
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create second member for multiparametric problems (reduced problem)
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi             : datastructure for empiric modes
! IO  ds_multipara        : datastructure for multiparametric problems
! In  i_coef              : index of coefficient
! Out  syst_2mbrROM       : second member on reduced model
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_mode_curr, nb_equa, nb_vect
    integer :: i_mode, i_vect
    aster_logical :: l_coef_cplx, l_coef_real
    real(kind=8) :: coef_r
    complex(kind=8) :: coef_c, coef_cplx
    complex(kind=8), pointer :: vc_vect_redu(:) => null()
    complex(kind=8), pointer :: vc_syst_2mbp(:) => null()
    real(kind=8), pointer :: vr_vect_redu(:) => null()
    real(kind=8), pointer :: vr_syst_2mbp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_66')
    endif
!
! - Initializations
!
    nb_mode_curr   = ds_empi%nb_mode
    nb_equa        = ds_empi%ds_mode%nbEqua
    nb_vect        = ds_multipara%nb_vect
!
! - Get second member
!
    if (ds_multipara%syst_type .eq.'R') then
       call jeveuo(syst_2mbrROM, 'E', vr = vr_syst_2mbp)
       vr_syst_2mbp(:) = 0.d0 
    else if (ds_multipara%syst_type .eq.'C') then
       call jeveuo(syst_2mbrROM, 'E', vc = vc_syst_2mbp)
       vc_syst_2mbp(:) = dcmplx(0.d0,0.d0) 
    else 
       ASSERT(ASTER_FALSE)
    end if 
!
! - Compute second member
!
    if (ds_multipara%syst_type .eq.'R') then      
        do i_vect = 1, nb_vect
            l_coef_cplx = ds_multipara%vect_coef(i_vect)%l_cplx
            l_coef_real = ds_multipara%vect_coef(i_vect)%l_real
            ASSERT(l_coef_real)
            coef_r = ds_multipara%vect_coef(i_vect)%coef_real(i_coef)
            call jeveuo(ds_multipara%vect_redu(i_vect), 'L', vr = vr_vect_redu)
            do i_mode = 1, nb_mode_curr
                vr_syst_2mbp(i_mode)=vr_syst_2mbp(i_mode)+vr_vect_redu(i_mode)*coef_r
            end do
        end do
    else if (ds_multipara%syst_type .eq.'C') then
        do i_vect = 1, nb_vect
            l_coef_cplx = ds_multipara%vect_coef(i_vect)%l_cplx
            l_coef_real = ds_multipara%vect_coef(i_vect)%l_real
            if (l_coef_cplx) then
                coef_c    = ds_multipara%vect_coef(i_vect)%coef_cplx(i_coef)
                coef_cplx = coef_c
            else
                coef_r    = ds_multipara%vect_coef(i_vect)%coef_real(i_coef)
                coef_cplx = dcmplx(coef_r)
            endif 
            call jeveuo(ds_multipara%vect_redu(i_vect), 'L', vc = vc_vect_redu)
            do i_mode = 1, nb_mode_curr
                vc_syst_2mbp(i_mode)=vc_syst_2mbp(i_mode)+vc_vect_redu(i_mode)*coef_cplx
            end do
        end do
    else 
       ASSERT(ASTER_FALSE)
    end if
!
end subroutine
