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
subroutine comp_meca_info(l_implex, ds_compor_prep)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterfort/comp_meca_init.h"
!
aster_logical, intent(in) :: l_implex
type(Behaviour_PrepPara), intent(out) :: ds_compor_prep
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Create datastructure to prepare comportement
!
! --------------------------------------------------------------------------------------------------
!
! In  l_implex         : .true. if IMPLEX method
! Out ds_compor_prep   : datastructure to prepare comportement
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywordfact
    integer :: nb_info_comp, nbocc_compor
    type(Behaviour_Parameters) :: ds_comporPara
!
! --------------------------------------------------------------------------------------------------
!
    nbocc_compor = 0
    keywordfact  = 'COMPORTEMENT'
    call getfac(keywordfact, nbocc_compor)
!
! - Initializations
!
    ds_compor_prep%v_comp   => null()
    ds_compor_prep%v_exte   => null()
    ds_compor_prep%l_implex = l_implex
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
    ds_compor_prep%nb_comp = nbocc_compor
!
! - Allocate comportment informations objects 
!
    allocate(ds_compor_prep%v_comp(nb_info_comp))
!
! - Allocate comportment informations objects (external: UMAT and MFront)
!
    allocate(ds_compor_prep%v_exte(nb_info_comp))
!
! - If nothing in COMPORTEMENT: all is elastic
!
    call comp_meca_init(ds_comporPara)
    if (nbocc_compor .eq. 0) then
        ds_compor_prep%v_comp(1) = ds_comporPara
        ds_compor_prep%v_comp(1)%rela_comp = 'ELAS'
        ds_compor_prep%v_comp(1)%defo_comp = 'PETIT'
        ds_compor_prep%v_comp(1)%type_comp = 'COMP_ELAS'
        ds_compor_prep%v_comp(1)%type_cpla = 'ANALYTIQUE'
    endif
!
end subroutine
