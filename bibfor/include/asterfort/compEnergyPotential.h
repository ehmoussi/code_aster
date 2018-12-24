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
    subroutine compEnergyPotential(option , modelz , ligrel, compor, l_temp,&
                                   chdispz, chtempz,&
                                   chharm , chgeom , chmate, chcara, chtime,&
                                   chvarc , chvref , &
                                   basez  , chelemz, codret)
        character(len=*), intent(in) :: option, modelz, ligrel, compor
        aster_logical, intent(in) :: l_temp
        character(len=*), intent(in) :: chdispz, chtempz
        character(len=*), intent(in) :: chharm, chgeom, chmate, chcara(*), chtime
        character(len=*), intent(in) :: chvarc, chvref
        character(len=*), intent(in) :: chelemz, basez
        integer, intent(out) :: codret
    end subroutine compEnergyPotential
end interface
