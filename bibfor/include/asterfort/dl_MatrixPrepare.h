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
!
interface
    subroutine dl_MatrixPrepare(l_harm    , l_damp    , l_damp_modal, l_impe    , resu_type,&
                                matr_mass_, matr_rigi_, matr_damp_  , matr_impe_,&
                                nb_matr   , matr_list , coef_type   , coef_vale ,&
                                matr_resu)
        aster_logical, intent(in) :: l_harm, l_damp, l_damp_modal, l_impe
        character(len=1), intent(in) :: resu_type
        character(len=*), intent(in) :: matr_mass_, matr_rigi_, matr_damp_, matr_impe_
        integer, intent(out) :: nb_matr
        character(len=24), intent(out) :: matr_list(*)
        character(len=1), intent(out) :: coef_type(*)
        real(kind=8), intent(out) :: coef_vale(*)
        character(len=8), intent(out) :: matr_resu
    end subroutine dl_MatrixPrepare
end interface
