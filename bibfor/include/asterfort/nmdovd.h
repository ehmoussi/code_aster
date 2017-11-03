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
#include "asterf_types.h"
!
interface
    subroutine nmdovd(model         , l_affe_all  , l_auto_deborst,&
                      list_elem_affe, nb_elem_affe, full_elem_s   ,&
                      defo_comp     , defo_comp_py)
        character(len=8), intent(in) :: model
        character(len=24), intent(in) :: list_elem_affe
        aster_logical, intent(in) :: l_affe_all
        aster_logical, intent(in) :: l_auto_deborst
        integer, intent(in) :: nb_elem_affe
        character(len=19), intent(in) :: full_elem_s
        character(len=16), intent(in) :: defo_comp
        character(len=16), intent(in) :: defo_comp_py
    end subroutine nmdovd
end interface
