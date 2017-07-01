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
    subroutine getBehaviourAlgo(plane_stress, rela_comp  , meca_comp,&
                                keywf       , i_comp     ,&
                                algo_inte   , algo_inte_r)
        aster_logical, intent(in) :: plane_stress
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: meca_comp
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: i_comp
        character(len=16), intent(out) :: algo_inte
        real(kind=8), intent(out) :: algo_inte_r
    end subroutine getBehaviourAlgo
end interface
