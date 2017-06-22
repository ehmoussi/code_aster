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

subroutine romMultiParaSystEvalType(ds_multipara,&
                                    syst_matr_type, syst_2mbr_type, syst_type)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_MultiPara), intent(in) :: ds_multipara
    character(len=1), intent(out) :: syst_matr_type
    character(len=1), intent(out) :: syst_2mbr_type
    character(len=1), intent(out) :: syst_type
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Evaluate type of system
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! Out syst_matr_type   : type of matrix (real or complex)
! Out syst_2mbr_type   : type of second member (real or complex)
! Out syst_type        : global type of system (real or complex)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_matr, nb_matr
    character(len=1) :: matr_type, vect_type
    aster_logical :: l_coefm_cplx, l_coefv_cplx
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_26')
    endif
!
! - Initializations
!
    syst_2mbr_type = 'R'
    syst_matr_type = 'R'
    syst_type      = 'R'
!
! - Get parameters
!
    nb_matr   = ds_multipara%nb_matr
!
! - Evaluate type of resultant matrix
!
    do i_matr = 1, nb_matr
        matr_type    = ds_multipara%matr_type(i_matr)
        l_coefm_cplx = ds_multipara%matr_coef(i_matr)%l_cplx
        if (matr_type .eq. 'C') then
            syst_matr_type = 'C'
            exit
        endif
        if (l_coefm_cplx) then
            syst_matr_type = 'C'
            exit
        endif
    end do
!
! - Evaluate type of second member
!
    vect_type      = ds_multipara%vect_type
    l_coefv_cplx   = ds_multipara%vect_coef%l_cplx
    if (vect_type .eq. 'C') then
        syst_2mbr_type = 'C'
    endif
    if (l_coefv_cplx) then
        syst_2mbr_type = 'C'
    endif
!
! - To be consistent
!  
    if (syst_matr_type .eq. 'C' .or. syst_2mbr_type .eq. 'C') then
        syst_type = 'C'
    endif
    if (syst_matr_type .eq. 'C') then
        syst_2mbr_type = 'C'
    endif
    if (syst_2mbr_type .eq. 'C') then
        syst_matr_type = 'C'
    endif
!
end subroutine
