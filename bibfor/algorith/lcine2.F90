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

function lcine2(d, gm, pm, c, dgamma,&
                alpham, x)
    implicit none
#include "asterc/r8prem.h"
    real(kind=8) :: d, gm, pm, c, dgamma, alpham, absdga, lcine2, x, alpha
    real(kind=8) :: signe
! person_in_charge: jean-michel.proix at edf.fr
    absdga=abs(dgamma)
    lcine2=x*(1.d0+d*absdga)+d*alpham*absdga-dgamma
    alpha=alpham+x
    if (abs(alpha) .gt. r8prem()) then
        signe=alpha/abs(alpha)
        lcine2=lcine2+((c*abs(alpha)/gm)**pm)*signe
    endif
end function
