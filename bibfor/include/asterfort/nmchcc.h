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

!
!
#include "asterf_types.h"
!
interface
    subroutine nmchcc(list_func_acti, nb_matr    , list_matr_type, list_calc_opti, list_asse_opti,&
                      list_l_asse  , list_l_calc)
        integer, intent(in) :: list_func_acti(*)
        integer, intent(inout) :: nb_matr
        character(len=6), intent(inout)  :: list_matr_type(20)
        character(len=16), intent(inout) :: list_calc_opti(20)
        character(len=16), intent(inout) :: list_asse_opti(20)
        aster_logical, intent(inout) :: list_l_asse(20)
        aster_logical, intent(inout) :: list_l_calc(20)
    end subroutine nmchcc
end interface
