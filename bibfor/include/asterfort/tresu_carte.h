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
    subroutine tresu_carte(cham19, nomail, nocmp, tbtxt, refi,&
                           refr, refc, typres, epsi, crit,&
                           llab, ignore, compare)
        character(len=*), intent(in) :: cham19
        character(len=*), intent(in) :: nomail
        character(len=*), intent(in) :: nocmp
        character(len=16), intent(in) :: tbtxt(2)
        integer, intent(in) :: refi
        real(kind=8), intent(in) :: refr
        complex(kind=8), intent(in) :: refc
        character(len=*), intent(in) :: typres
        real(kind=8), intent(in) :: epsi
        character(len=*), intent(in) :: crit
        aster_logical, intent(in) :: llab
        aster_logical, intent(in), optional :: ignore
        real(kind=8), intent(in), optional :: compare
    end subroutine tresu_carte
end interface
