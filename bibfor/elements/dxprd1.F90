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

subroutine dxprd1(dfpla1, dfpla2, dc, dfpla3, dfpla4,&
                  mat)
!     REALISE LE CALCUL DES MATRICES INTERVENANT DANS LE
!     CALCUL DE TANGENTE DANS LE CAS DE LA LOI DE COMPORTEMENT GLRC
! ----------------------------------------------------------------------
    implicit none
#include "asterfort/lcprte.h"
#include "asterfort/pmat.h"
    common /tdim/ n, nd
    real(kind=8) :: dfpla1(6), dfpla2(6), dfpla3(6), dfpla4(6)
    real(kind=8) :: mata(6, 6), matb(6, 6), matc(6, 6), mat(6, 6)
    real(kind=8) :: dc(6, 6)
    integer :: n, nd
!
    n = 6
    call lcprte(dfpla1, dfpla2, mata)
    call lcprte(dfpla3, dfpla4, matb)
    call pmat(6, mata, dc, matc)
    call pmat(6, matc, matb, mat)
!
end subroutine
