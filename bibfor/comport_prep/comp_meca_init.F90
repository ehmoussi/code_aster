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
! aslint: disable=W1403
! person_in_charge: mickael.abbas at edf.fr
!
subroutine comp_meca_init(ds_comporPara)
!
use Behaviour_type
!
implicit none
!
#include "asterc/getfac.h"
!
type(Behaviour_Parameters), intent(out) :: ds_comporPara
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Init datastructure to describe comportement
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_comporPara    : datastructure to describe comportement
!
! --------------------------------------------------------------------------------------------------
!
    ds_comporPara%rela_comp       = 'VIDE'
    ds_comporPara%defo_comp       = 'VIDE'
    ds_comporPara%type_comp       = 'VIDE'
    ds_comporPara%type_cpla       = 'VIDE'
    ds_comporPara%kit_comp(:)     = 'VIDE'
    ds_comporPara%mult_comp       = 'VIDE'
    ds_comporPara%post_iter       = 'VIDE'
    ds_comporPara%nb_vari         = 0
    ds_comporPara%nb_vari_comp(:) = 0
    ds_comporPara%nume_comp(:)    = 0
!
end subroutine
