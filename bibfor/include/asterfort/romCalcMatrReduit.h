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
#include "asterf_types.h"
!
interface
    subroutine romCalcMatrReduit(i_mode, ds_empi, nb_matr, prod_matr_mode, matr_redu,&
                             mode_type)
        use Rom_Datastructure_type
        integer, intent(in) :: nb_matr, i_mode
        type(ROM_DS_Empi), intent(in) :: ds_empi
        character(len=24), intent(in) :: matr_redu(:)
        character(len=24), intent(in) :: prod_matr_mode(:)
        character(len=1), intent(in) :: mode_type
    end subroutine romCalcMatrReduit
end interface
