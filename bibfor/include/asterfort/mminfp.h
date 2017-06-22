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
    subroutine mminfp(i_zone , sdcont_defi, question_, vale_i_, vale_r_,&
                      vale_l_)
        character(len=24), intent(in) :: sdcont_defi
        character(len=*), intent(in) :: question_
        integer, intent(in) :: i_zone
        real(kind=8), optional, intent(out) :: vale_r_
        integer, optional, intent(out) :: vale_i_
        aster_logical, optional, intent(out) :: vale_l_
    end subroutine mminfp
end interface
