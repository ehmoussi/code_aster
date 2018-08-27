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
subroutine romMultiParaDSInit(ds_multipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
!
type(ROM_DS_MultiPara), intent(out) :: ds_multipara
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialisation of datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_multipara     : datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
    ds_multipara%prod_mode(1)    = '&&OP0053.PRODMODE_1'
    ds_multipara%prod_mode(2)    = '&&OP0053.PRODMODE_2'
    ds_multipara%prod_mode(3)    = '&&OP0053.PRODMODE_3'
    ds_multipara%prod_mode(4)    = '&&OP0053.PRODMODE_4'
    ds_multipara%prod_mode(5)    = '&&OP0053.PRODMODE_5'
    ds_multipara%prod_mode(6)    = '&&OP0053.PRODMODE_6'
    ds_multipara%prod_mode(7)    = '&&OP0053.PRODMODE_7'
    ds_multipara%prod_mode(8)    = '&&OP0053.PRODMODE_8'
!
end subroutine
