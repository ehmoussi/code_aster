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
    subroutine gcharg(modele, lischa, chvolu, ch1d2d,ch2d3d,&
                      chpres, chepsi, chpesa, chrota,lfonc,&
                      time, iord)
        character(len=8) :: modele
        character(len=19) :: lischa
        character(len=19) :: chvolu
        character(len=19) :: ch1d2d
        character(len=19) :: ch2d3d
        character(len=19) :: chpres
        character(len=19) :: chepsi
        character(len=19) :: chpesa
        character(len=19) :: chrota
        aster_logical :: lfonc
        real(kind=8) :: time
        integer :: iord
    end subroutine gcharg
end interface
