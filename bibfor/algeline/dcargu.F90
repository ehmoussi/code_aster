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

function dcargu(c)
    implicit none
! CALCUL DE L'ARGUMENT D'UN NOMBRE COMPLEXE
! PAR CONVENTION ON AFFECTE 0.D0 SI C = (0.D0,0.D0)
!-----------------------------------------------------------------------
!  IN : C : NOMBRE COMPLEXE DONT ON VEUT CALCULER L'ARGUMENT
!-----------------------------------------------------------------------
#include "asterc/r8pi.h"
    real(kind=8) :: dcargu
    complex(kind=8) :: c
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    real(kind=8) :: pi
!-----------------------------------------------------------------------
    pi = r8pi()
!
    if (dble(c) .eq. 0.d0) then
        if (dimag(c) .gt. 0.d0) then
            dcargu = pi/2.d0
        else if (dimag(c).lt.0.d0) then
            dcargu = -pi/2.d0
        else
            dcargu = 0.d0
        endif
    else if (dble(c).gt.0.d0) then
        dcargu = dble(atan2(dimag(c),dble(c)))
    else if (dble(c).lt.0.d0) then
        dcargu = dble(atan2(dimag(c),dble(c))) + pi
    endif
    if (dcargu .lt. 0.d0) dcargu = dcargu + 2.d0*pi
!
end function
