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
    subroutine thmGetElemModel(l_axi_, l_vf_, l_steady_, ndim_, type_elem_)
        aster_logical, optional, intent(out) :: l_axi_, l_steady_, l_vf_
        integer, optional, intent(out) :: ndim_
        character(len=8), optional, intent(out) :: type_elem_(2)
    end subroutine thmGetElemModel
end interface 
