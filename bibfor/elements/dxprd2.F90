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

subroutine dxprd2(dfpla1, dca, dfpla2, dfpla3, dcb,&
                  dfpla4, scal)
!     REALISE LE CALCUL DES TERMES DU NUMERATEUR INTERVENANT DANS LE
!     CALCUL DE TANGENTE DANS LE CAS DE LA LOI DE COMPORTEMENT GLRC
! ----------------------------------------------------------------------
    implicit none
#include "asterfort/lcprsc.h"
#include "asterfort/pmavec.h"
    common /tdim/ n, nd
    real(kind=8) :: dfpla1(6), dfpla2(6), dfpla3(6), dfpla4(4)
    real(kind=8) :: vecta(6), vectb(6), dca(6, 6), dcb(6, 6)
    real(kind=8) :: scal1, scal2, scal
    integer :: n, nd
!
    n = 6
    call pmavec('ZERO', 6, dca, dfpla2, vecta)
    call lcprsc(dfpla1, vecta, scal1)
    call pmavec('ZERO', 6, dcb, dfpla4, vectb)
    call lcprsc(dfpla3, vectb, scal2)
    scal = scal1*scal2
!
end subroutine
