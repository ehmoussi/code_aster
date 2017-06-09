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

function jexnum(nomc, num)
    implicit none
#include "jeveux.h"
!
    character(len=32) :: jexnum
    character(len=*),intent(in) :: nomc
    integer,intent(in) :: num
!
    character(len=24) :: ch24
    character(len=8) :: ch8
!
    integer :: numec
    common /inumje/   numec
    real(kind=8) :: reelc
    common /reelje/   reelc
    character(len=24) :: nomec
    common /knomje/   nomec
!-----------------------------------------------------------------------
    data              ch8      / '$$XNUM  ' /
!
    numec = num
    nomec = ' '
    reelc = 0.d0
    ch24 = nomc
    jexnum( 1:24) = ch24
    jexnum(25:32) = ch8
end function
