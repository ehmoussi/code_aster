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
    subroutine mateMFrontGetProperties(nomrc_mfront , l_mfront_func, l_mfront_anis,&
                                       mfront_nbvale, mfront_prop  , mfront_valr  , mfront_valk)
        character(len=32), intent(inout) :: nomrc_mfront
        aster_logical, intent(out) :: l_mfront_func, l_mfront_anis
        real(kind=8), intent(out) :: mfront_valr(16)
        character(len=16), intent(out) :: mfront_valk(16)
        character(len=16), intent(out) :: mfront_prop(16)
        integer, intent(out) :: mfront_nbvale
    end subroutine mateMFrontGetProperties
end interface
