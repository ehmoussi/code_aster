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

function prgonf(biot, betam, pref, p1)
! ROUTINE PRGONF
! CALCUL DE LA PRESSION DE GONFLEMENT POUR L ARGILE GONFLANTE
! ======================================================================
!
    implicit none
#include "asterc/r8pi.h"
#include "asterfort/erfcfo.h"
    real(kind=8) :: biot, betam, pref, p1, prgonf, derf
    real(kind=8) :: pi, rpi, s, rbetam
!
    pi = r8pi()
    rpi=sqrt(pi)
    rbetam=sqrt(betam)
    betam=rbetam*rbetam
    s=p1/pref
    derf = (1.d0-erfcfo(s*rbetam))
    if (s .gt. 0.d0) then
        prgonf=pref*biot*((rpi/(2.d0*rbetam))*derf +(0.5d0/betam)*(&
        1.d0-exp(-betam*s*s)))
    else
        prgonf=pref*biot*s
    endif
end function
