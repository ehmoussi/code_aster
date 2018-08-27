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
subroutine romMultiParaROM2mbrCreate(ds_empi       , ds_multipara, i_coef,&
                                     syst_2mbr_type, syst_2mbr   , syst_2mbrROM)
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
character(len=1), intent(in) :: syst_2mbr_type
character(len=19), intent(in) :: syst_2mbr
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
! In  ds_empi          : datastructure for empiric modes
! IO  ds_multipara     : datastructure for multiparametric problems
! In  i_coef           : index of coefficient
! In  syst_2mbr_type   : type of second member (R or C)
! In  syst_2mbr        : second member
! In  syst_2mbrROM     : second member on reduced model
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_mode, nb_equa
    integer :: i_mode, i_equa, iret
    character(len=24) :: field_iden
    character(len=8) :: base
    complex(kind=8) :: term
    aster_logical :: l_coef_cplx, l_coef_real
    real(kind=8) :: coef_r
    complex(kind=8) :: coef_c, coef_cplx
    character(len=19) :: mode
    complex(kind=8), pointer :: v_mode(:) => null()
    complex(kind=8), pointer :: v_syst_2mbc(:) => null()
    real(kind=8), pointer :: v_syst_2mbr(:) => null()
    complex(kind=8), pointer :: v_syst_2mbp(:) => null()
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
    base           = ds_empi%base
    nb_mode        = ds_empi%nb_mode
    nb_equa        = ds_empi%ds_mode%nb_equa
!
! - Get second member
!
    if (syst_2mbr_type .eq. 'C') then
        call jeveuo(syst_2mbr(1:19)//'.VALE', 'L', vc = v_syst_2mbc)
    elseif (syst_2mbr_type .eq. 'R') then
        call jeveuo(syst_2mbr(1:19)//'.VALE', 'L', vr = v_syst_2mbr)
    else
        ASSERT(.false.)
    endif
    call jeveuo(syst_2mbrROM, 'E', vc = v_syst_2mbp)
!
! - Apply coefficient on second member
!
    l_coef_cplx = ds_multipara%vect_coef%l_cplx
    l_coef_real = ds_multipara%vect_coef%l_real 

    do i_mode = 1, nb_mode
        if (l_coef_cplx) then
            coef_c    = ds_multipara%vect_coef%coef_cplx(i_coef)
            coef_cplx = coef_c
        else
            coef_r    = ds_multipara%vect_coef%coef_real(i_coef)
            coef_cplx = dcmplx(coef_r)
        endif
        field_iden = 'DEPL'
        call rsexch(' ', base, field_iden, i_mode, mode, iret)
        call jeveuo(mode(1:19)//'.VALE', 'L', vc = v_mode)
        term = dcmplx(0.d0, 0.d0)
        do i_equa = 1, nb_equa
            term = term + coef_cplx*dcmplx(v_syst_2mbc(i_equa))*dconjg(v_mode(i_equa))
        end do
        v_syst_2mbp(i_mode) = term
    end do
!
end subroutine
