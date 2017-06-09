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

subroutine tempeq(z, tdeq, tfeq, k, n,&
                  teq, dvteq)
!
!
    implicit none
#include "asterc/r8prem.h"
    real(kind=8) :: z, tdeq, tfeq, k, n, teq, dvteq
    real(kind=8) :: zero
!
!............................................
! CALCUL PHASE METALLURGIQUE POUR EDGAR
! CALCUL DE LA TEMPERTURE EQUIVALENTE
!............................................
!
! IN   Z    : PROPORTION DE PHASE BETA
! IN   TDEQ : TEMPERATURE QUASISTATIQUE DE DEBUT DE TRANSFORMATION
! IN   TFEQ : TEMPERATURE QUASISTATIQUE DE FIN DE TRANSFORMATION
!             CORRESPONDANT A 0.99 DE PHASE BETA
! IN   K    : PARAMETRE MATERIAU
! IN   N    : PARAMETRE MATERIAU
! OUT TEQ   : TEMPERATURE EQUIVALENTE
! OUT DVTEQ : DERIVEE DE TEQ PAR RAPPORT A Z
!
    zero=r8prem()
    if (z .le. zero) then
        teq=tdeq
        dvteq=1000.d0
    else if (z .le. 0.99d0) then
        teq=tdeq+(log(1.d0/(1.d0-z)))**(1.d0/n)/k
        dvteq=-(log(1.d0/(1.d0-z)))**(1.d0/n)/(k*n*(1.d0-z)*log(1.d0-&
        z))
    else
        teq=tfeq
        dvteq=-(log(100.d0))**(1.d0/n)/(k*n*(0.01d0)*log(0.01d0))
    endif
!
end subroutine
