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
    subroutine tresu_champ_cmp(chamgd, typtes, typres, nbref, tbtxt,&
                      refi, refr, refc, epsi, lign1,&
                      lign2, crit, ific, nbcmp, nocmp,&
                      llab, ssigne, ignore, compare)
        character(len=*), intent(in) :: chamgd
        character(len=8), intent(in) :: typtes
        character(len=*), intent(in) :: typres
        integer, intent(in) :: nbref
        character(len=16), intent(in) :: tbtxt(2)
        integer, intent(in) :: refi(nbref)
        real(kind=8), intent(in) :: refr(nbref)
        complex(kind=8), intent(in) :: refc(nbref)
        real(kind=8), intent(in) :: epsi
        character(len=200), intent(inout) :: lign1
        character(len=200), intent(inout) :: lign2
        character(len=*), intent(in) :: crit
        integer, intent(in) :: ific
        integer, intent(in) :: nbcmp
        character(len=8), intent(in) :: nocmp(*)
        aster_logical, intent(in) :: llab
        character(len=*), intent(in) :: ssigne
        aster_logical, intent(in), optional :: ignore
        real(kind=8), intent(in), optional :: compare
    end subroutine tresu_champ_cmp
end interface
