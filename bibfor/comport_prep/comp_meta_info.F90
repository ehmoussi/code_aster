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
! aslint: disable=W1003
! person_in_charge: mickael.abbas at edf.fr
!
subroutine comp_meta_info(ds_comporMeta)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
!
type(META_PrepPara), intent(out) :: ds_comporMeta
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (metallurgy)
!
! Create datastructure to prepare comportement
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_comporMeta    : datastructure to prepare comportement
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
    ds_comporMeta%v_comp   => null()
!
! - Number of comportement information
!
    if (nbocc_compor .eq. 0) then
        nb_info_comp = 1
    else
        nb_info_comp = nbocc_compor
    endif
!
! - Save number of comportments
!
    ds_comporMeta%nb_comp = nbocc_compor
!
! - Allocate comportment informations objects 
!
    allocate(ds_comporMeta%v_comp(nb_info_comp))
!
end subroutine
