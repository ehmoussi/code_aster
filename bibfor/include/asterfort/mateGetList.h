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
!
#include "asterf_types.h"
!
interface
    subroutine mateGetList(mate_nb_read , v_mate_read  ,&
                           l_mfront_elas,&
                           l_elas       , l_elas_func  , l_elas_istr,&
                           l_elas_orth  , l_elas_meta  ,&
                           i_mate_elas  , i_mate_mfront)
        integer, intent(out) :: mate_nb_read
        character(len=32), pointer, intent(out) :: v_mate_read(:)
        aster_logical, intent(out) :: l_mfront_elas
        aster_logical, intent(out) :: l_elas, l_elas_func
        aster_logical, intent(out) :: l_elas_istr, l_elas_orth, l_elas_meta
        integer, intent(out) :: i_mate_elas, i_mate_mfront
    end subroutine mateGetList
end interface
