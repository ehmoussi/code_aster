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
! person_in_charge: mathieu.courtois at edf.fr
!
#include "asterf_types.h"
!
interface
    subroutine tresu_print_all(refer, legend, llab, typres, nbref, &
                               rela, tole, ssigne, refr, valr, &
                               refi, vali, refc, valc, ignore, &
                               compare)
        implicit none
        character(len=16), intent(in) :: refer
        character(len=16), intent(in) :: legend
        aster_logical, intent(in) :: llab
        character(len=*), intent(in) :: typres
        integer, intent(in) :: nbref
        character(len=*), intent(in) :: rela
        real(kind=8), intent(in) :: tole
        character(len=*), intent(in) :: ssigne
        real(kind=8), intent(in) :: refr(nbref)
        real(kind=8), intent(in) :: valr
        integer, intent(in) :: refi(nbref)
        integer, intent(in) :: vali
        complex(kind=8), intent(in) :: refc(nbref)
        complex(kind=8), intent(in) :: valc
        aster_logical, intent(in), optional :: ignore
        real(kind=8), intent(in), optional :: compare
    end subroutine tresu_print_all
end interface
