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

function phase(h)
    implicit none
!     RENVOIT LA PHASE DE H COMPRISE ENTRE 0. ET 2PI
!     ------------------------------------------------------------------
#include "asterc/r8pi.h"
    complex(kind=8) :: h
    real(kind=8) :: x, y, phase, pi
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    pi=r8pi()
    x=dble(h)
    y=dimag(h)
    phase=0.d0
    if ((x.gt.0.d0) .and. (y.ge.0.d0)) phase=atan2(y,x)
    if ((x.lt.0.d0) .and. (y.ge.0.d0)) phase=atan2(y,x)+pi
    if ((x.lt.0.d0) .and. (y.le.0.d0)) phase=atan2(y,x)+pi
    if ((x.gt.0.d0) .and. (y.le.0.d0)) phase=atan2(y,x)+2.d0*pi
    if ((x.eq.0.d0) .and. (y.lt.0.d0)) phase=3.d0*pi/2.d0
    if ((x.eq.0.d0) .and. (y.gt.0.d0)) phase=pi/2.d0
    if ((x.eq.0.d0) .and. (y.eq.0.d0)) phase=0.d0
end function
