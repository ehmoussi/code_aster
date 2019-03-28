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
subroutine romMultiParaProdModeInit(ds_multipara, nb_mode_maxi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/vtcrem.h"
#include "asterfort/wkvect.h"
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
integer, intent(in) :: nb_mode_maxi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Initializations for products matrix x mode, reduced matrix and reduced vector
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! In  nb_mode_maxi     : maximum number of empirical modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_matr, nb_matr, jv_dummy, nb_equa
    character(len=24) :: prod_matr_mode
    character(len=19) ::matr_mode_curr
    character(len=8) :: matr_name
    character(len=1) :: matr_type, prod_type, syst_type
    aster_logical :: l_coefm_cplx
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_34')
    endif
!
! - Get parameters
!
    nb_matr   = ds_multipara%nb_matr
    syst_type = ds_multipara%syst_type
    nb_equa   = ds_multipara%nb_equa
!
! - Prepare product [Matrix] x [Mode]
!
    do i_matr = 1, nb_matr
        matr_mode_curr = ds_multipara%matr_mode_curr(i_matr)
        matr_name      = ds_multipara%matr_name(i_matr)
        matr_type      = ds_multipara%matr_type(i_matr)
        l_coefm_cplx   = ds_multipara%matr_coef(i_matr)%l_cplx
        prod_type      = 'R'
        if (matr_type .eq. 'C' .or. l_coefm_cplx .or. syst_type .eq. 'C') then
            prod_type    = 'C'
        endif
        call vtcrem(matr_mode_curr, matr_name, 'V', prod_type)
        call wkvect(ds_multipara%matr_redu(i_matr), 'V V '//syst_type, nb_mode_maxi*nb_mode_maxi,&
                    jv_dummy)
        prod_matr_mode = ds_multipara%prod_matr_mode(i_matr)
        call wkvect(prod_matr_mode, 'V V '//syst_type, nb_mode_maxi*nb_equa, jv_dummy)
    end do
!
! - Prepare Reduced Vector
!
    call wkvect(ds_multipara%vect_redu, 'V V '//syst_type, nb_mode_maxi, jv_dummy)
!
end subroutine
