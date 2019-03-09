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
subroutine romMultiParaDOM2mbrCreate(ds_multipara, i_coef, ds_solve)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/vtcmbl.h"
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
integer, intent(in) :: i_coef
type(ROM_DS_Solve), intent(in) :: ds_solve
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create second member for multiparametric problems (complete problem)
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! In  i_coef           : index of coefficient
! In  ds_solve         : datastructure to solve systems
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nb_vect_maxi = 8
    character(len=1) :: type_comb(nb_vect_maxi)
    real(kind=8) :: coef_comb(2*nb_vect_maxi)
    character(len=24) :: vect_comb(nb_vect_maxi)
    character(len=1)  :: type_vect_comb(nb_vect_maxi)
    character(len=8)  :: vect_name
    integer :: i_coef_comb, i_vect, nb_vect
    aster_logical :: l_coefv_cplx
    character(len=1) :: syst_2mbr_type
    character(len=19) :: syst_2mbr
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_62')
    endif
!
! - Initializations
!
    syst_2mbr         = ds_solve%syst_2mbr
    syst_2mbr_type    = ds_solve%syst_2mbr_type
    nb_vect           = ds_multipara%nb_vect
    ASSERT(nb_vect .le. nb_vect_maxi)
    type_comb(:)      = ''
    vect_comb(:)      = ''
    coef_comb(:)      = 0.d0
    type_vect_comb(:) = ''
!
! - Compute second member
!
    i_coef_comb = 0
    do i_vect = 1, nb_vect
        vect_name              = ds_multipara%vect_name(i_vect)
        vect_comb(i_vect)      = vect_name(1:8)//'           .VALE'
        type_vect_comb(i_vect) = ds_multipara%vect_type(i_vect)
        l_coefv_cplx           = ds_multipara%vect_coef(i_vect)%l_cplx
        if (l_coefv_cplx) then
            type_comb(i_vect) = 'C'
            i_coef_comb = i_coef_comb +1
            coef_comb(i_coef_comb) = real(ds_multipara%vect_coef(i_vect)%coef_cplx(i_coef))
            i_coef_comb = i_coef_comb +1
            coef_comb(i_coef_comb) = dimag(ds_multipara%vect_coef(i_vect)%coef_cplx(i_coef))
        else
            type_comb(i_vect) = 'R'
            i_coef_comb = i_coef_comb +1
            coef_comb(i_coef_comb) = ds_multipara%vect_coef(i_vect)%coef_real(i_coef)
        endif
    end do
    call vtcmbl(nb_vect, type_comb, coef_comb, type_vect_comb, vect_comb,&
                syst_2mbr_type, syst_2mbr//'.VALE')
!
end subroutine
