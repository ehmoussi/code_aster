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
    subroutine dl_CreateDampMatrix(matr_rigi   , matr_mass  , l_cplx,&
                                   nb_damp_read, l_damp_read,&
                                   matr_damp)
        character(len=19), intent(in) :: matr_rigi, matr_mass
        aster_logical, intent(in) :: l_cplx
        real(kind=8), pointer :: l_damp_read(:)
        integer, intent(in) :: nb_damp_read
        character(len=19), intent(out)  :: matr_damp
    end subroutine dl_CreateDampMatrix
end interface
