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
    subroutine nmcrls(sddisc   , list_inst  , nume_ini, nume_end, l_init_noexist,&
                      inst_init, nb_inst_new, dtmin)
        character(len=19), intent(in) :: sddisc
        character(len=19), intent(in) :: list_inst
        integer, intent(in) :: nume_ini
        integer, intent(in) :: nume_end
        aster_logical, intent(in) :: l_init_noexist
        real(kind=8), intent(in) :: inst_init
        integer, intent(out) :: nb_inst_new
        real(kind=8), intent(out) :: dtmin
    end subroutine nmcrls
end interface
