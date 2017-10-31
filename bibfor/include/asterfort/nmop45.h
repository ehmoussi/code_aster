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
    subroutine nmop45(eigsol, l_hpp, mod45, modes, modes2, ds_posttimestep_)
        use NonLin_Datastructure_type          
        character(len=19), intent(in) :: eigsol
        aster_logical    , intent(in) :: l_hpp
        character(len=4) , intent(in) :: mod45
        character(len=8) , intent(in) :: modes
        character(len=8) , intent(in) :: modes2
        type(NL_DS_PostTimeStep), optional, intent(in) :: ds_posttimestep_
    end subroutine nmop45
end interface
