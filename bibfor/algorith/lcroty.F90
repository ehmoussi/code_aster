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

function lcroty(t, prec, itemax)
    implicit none
#include "asterfort/utmess.h"
    real(kind=8) :: lcroty
    integer :: itemax
    real(kind=8) :: t, prec
!
! *****************************************************
!       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL     *
!           RESOLUTION Y.EXP(Y) = T                   *
! *****************************************************
!
! IN  T       : SECOND MEMBRE CONSTANT
! IN  PREC    : PRECISION RELATIVE SOUHAITEE
! IN  ITEMAX  : NOMBRE MAX D'ITERATIONS
!
    integer :: iter
    real(kind=8) :: y, u, h, dh
!
! 1 - NEWTON SANS CHANGEMENT DE VARIABLE
!
    if (t .le. exp(1.d0)) then
!
        y = 0.d0
        do 10 iter = 1, itemax
            h = y*exp(y) - t
            dh = (1+y) * exp(y)
            if (abs(h) .le. prec*t) goto 100
            y = y - h/dh
10      continue
!
!
! 2 - NEWTON AVEC CHANGEMENT DE VARIABLE U=EXP(Y)
!
    else
        u = t
        do 20 iter = 1, itemax
            h = u*log(u) - t
            dh = 1 + log(u)
            if (abs(h) .le. prec*t) then
                y = log(u)
                goto 100
            endif
            u = u - h/dh
20      continue
    endif
!
    call utmess('F', 'ALGORITH3_55')
!
!
100  continue
    lcroty = y
end function
