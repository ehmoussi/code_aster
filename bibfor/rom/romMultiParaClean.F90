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

subroutine romMultiParaClean(ds_multipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/romMultiCoefClean.h"
#include "asterfort/romVariParaClean.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_MultiPara), intent(inout) :: ds_multipara
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Clean datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_multipara     : datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_matr, nb_matr, i_vari_para, nb_vari_para
!
! --------------------------------------------------------------------------------------------------
!
    nb_matr = ds_multipara%nb_matr
    do i_matr = 1, nb_matr
        call romMultiCoefClean(ds_multipara%matr_coef(i_matr))
    end do
    call romMultiCoefClean(ds_multipara%vect_coef)
    nb_vari_para = ds_multipara%nb_vari_para
    do i_vari_para = 1, nb_vari_para
        call romVariParaClean(ds_multipara%vari_para(i_vari_para))
    end do
!
end subroutine
