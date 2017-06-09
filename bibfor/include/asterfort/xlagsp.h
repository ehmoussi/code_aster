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
    subroutine xlagsp(mesh        , model, crack, algo_lagr, nb_dim,&
                      sdline_crack, l_pilo, tabai, l_ainter)
        integer, intent(in) :: nb_dim
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        character(len=8), intent(in)  :: crack
        integer, intent(in) :: algo_lagr
        character(len=14), intent(in) :: sdline_crack
        aster_logical, intent(in) :: l_pilo, l_ainter
        character(len=19) :: tabai
    end subroutine xlagsp
end interface
