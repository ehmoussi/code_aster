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
    subroutine mateReuseMngt(mateOUT  , mateOUT_nb  , mateOUT_list, &
                             mateREUSE, mateREUSE_nb)
        character(len=8), intent(in) :: mateOUT
        integer, intent(in) :: mateOUT_nb
        character(len=32), pointer, intent(in) :: mateOUT_list(:)
        character(len=8), intent(out) :: mateREUSE
        integer, intent(out) :: mateREUSE_nb
    end subroutine mateReuseMngt
end interface
