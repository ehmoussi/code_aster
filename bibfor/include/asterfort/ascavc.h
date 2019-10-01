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
#include "asterf_types.h"
!
interface
    subroutine ascavc(lchar, infcha, fomult, numedd, inst, vci,&
                      l_hho_, hhoField_)
        use HHO_type
        character(len=24) :: lchar
        character(len=24) :: infcha
        character(len=24) :: fomult
        character(len=*) :: numedd
        real(kind=8) :: inst
        character(len=*) :: vci
        aster_logical, intent(in), optional :: l_hho_
        type(HHO_Field), intent(in), optional :: hhoField_
    end subroutine ascavc
end interface
