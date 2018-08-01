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
! aslint: disable=W1403
!
subroutine romVariParaDSInit(ds_varipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
!
type(ROM_DS_VariPara), intent(out) :: ds_varipara
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Variation of parameters for multiparametric problems - Initializations
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_varipara      : datastructure for multiparametric problems - Variations
!
! --------------------------------------------------------------------------------------------------
!
    ds_varipara%nb_vale_para = 0
    ds_varipara%para_name    = ' '
    ds_varipara%para_vale    => null()
    ds_varipara%para_init    = 0.d0
!
end subroutine
