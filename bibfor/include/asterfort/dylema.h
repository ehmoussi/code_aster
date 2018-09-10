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
#include "asterf_types.h"
!
interface
    subroutine dylema(matr_rigi   , matr_mass, matr_damp, matr_impe,&
                      l_damp_modal, l_damp   , l_impe   ,&
                      nb_matr     , matr_list, coef_type, coef_vale,&
                      matr_resu   , numddl   , nb_equa)
        character(len=19), intent(out) :: matr_mass, matr_rigi, matr_damp, matr_impe
        aster_logical, intent(out) :: l_damp_modal, l_damp, l_impe
        integer, intent(out) :: nb_matr
        character(len=24), intent(out) :: matr_list(*)
        character(len=1), intent(out) :: coef_type(*)
        real(kind=8), intent(out) :: coef_vale(*)
        character(len=19), intent(out) :: matr_resu
        character(len=14), intent(out) :: numddl
        integer, intent(out) :: nb_equa
    end subroutine dylema
end interface
