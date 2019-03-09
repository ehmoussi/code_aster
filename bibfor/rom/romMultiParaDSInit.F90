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
subroutine romMultiParaDSInit(ds_multipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/codent.h"
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
    integer :: nb_matr_max = 8, nb_vect_max = 8
    integer :: i_matr, i_vect
    character(len=4) :: knume
!
! --------------------------------------------------------------------------------------------------
!
    do i_matr = 1, nb_matr_max
        call codent(i_matr, 'D0', knume)
        ds_multipara%matr_mode_curr(i_matr) = '&&OP0053.MAMOC_'//knume
        ds_multipara%prod_matr_mode(i_matr) = '&&OP0053.MATR_MODE_'//knume
        ds_multipara%matr_redu(i_matr)      = '&&OP0053.M_REDUITE_'//knume
    end do
!
    do i_vect = 1, nb_vect_max
        call codent(i_vect, 'D0', knume)
        ds_multipara%vect_redu(i_vect) = '&&OP0053.V_REDUIT_'//knume
    end do
!
end subroutine
