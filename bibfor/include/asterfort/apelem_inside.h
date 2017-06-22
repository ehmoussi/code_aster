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
    subroutine apelem_inside(pair_tole   , elem_dime, elem_code,&
                             nb_poin_coor, poin_coor,&
                             nb_poin_inte, poin_inte)
        real(kind=8), intent(in) :: pair_tole
        integer, intent(in) :: elem_dime
        character(len=8), intent(in) :: elem_code
        integer, intent(in) :: nb_poin_coor
        real(kind=8), intent(in) :: poin_coor(elem_dime-1,4)
        integer, intent(inout) :: nb_poin_inte
        real(kind=8), intent(inout) :: poin_inte(elem_dime-1,16)
    end subroutine apelem_inside
end interface
