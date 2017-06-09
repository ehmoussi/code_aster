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
    subroutine tresu_champ_no(cham19, nonoeu, nocmp, nbref, tbtxt,&
                      refi, refr, refc, typres, epsi,&
                      crit,  llab, ssigne, ignore, compare)
        character(len=19), intent(in) :: cham19
        character(len=33), intent(in) :: nonoeu
        character(len=8), intent(in) :: nocmp
        integer, intent(in) :: nbref
        character(len=16), intent(in) :: tbtxt(2)
        integer, intent(in) :: refi(nbref)
        real(kind=8), intent(in) :: refr(nbref)
        complex(kind=8), intent(in) :: refc(nbref)
        character(len=1), intent(in) :: typres
        real(kind=8), intent(in) :: epsi
        character(len=*), intent(in) :: crit
        aster_logical, intent(in) :: llab
        character(len=*), intent(in) :: ssigne
        aster_logical, intent(in), optional :: ignore
        real(kind=8), intent(in), optional :: compare
    end subroutine tresu_champ_no
end interface
