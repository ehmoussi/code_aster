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

subroutine carc_info(ds_compor_para)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterc/getfac.h"
#include "asterfort/as_allocate.h"
!
! aslint: disable=W1003
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_ComporParaPrep), intent(out) :: ds_compor_para
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Create comportment informations objects
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_compor_para   : datastructure to prepare parameters for constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywordfact
    integer :: nb_info_comp, nbocc_compor
!
! --------------------------------------------------------------------------------------------------
!
    nbocc_compor = 0
    keywordfact  = 'COMPORTEMENT'
    call getfac(keywordfact, nbocc_compor)
!
! - Initializations
!
    ds_compor_para%v_para => null()
!
! - Number of comportement information
!
    if (nbocc_compor.eq.0) then
        nb_info_comp = 1
    else
        nb_info_comp = nbocc_compor
    endif
!
! - Save number of comportments
!
    ds_compor_para%nb_comp = nbocc_compor
!
! - Allocate objects
!
    allocate(ds_compor_para%v_para(nb_info_comp))
!
end subroutine
