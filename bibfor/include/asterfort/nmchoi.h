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
    subroutine nmchoi(phase , sddyna, nume_inst, list_func_acti, reasma,&
                      metpre, metcor, lcamor   , optrig        , lcrigi,&
                      larigi, lcfint)
        character(len=10), intent(in) :: phase
        character(len=19), intent(in) :: sddyna
        integer, intent(in) :: nume_inst, list_func_acti(*)
        aster_logical, intent(in) :: reasma, lcamor
        character(len=16), intent(in) :: metcor, metpre
        character(len=16), intent(out) :: optrig
        aster_logical, intent(out) :: lcrigi, lcfint, larigi
    end subroutine nmchoi
end interface
