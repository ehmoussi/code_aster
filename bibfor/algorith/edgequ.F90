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

function edgequ(ndimsi, tens, ani)
!
    implicit none
    real(kind=8) :: edgequ
!
!
#include "asterc/r8prem.h"
#include "asterfort/utmess.h"
    integer :: ndimsi
    real(kind=8) :: tens(ndimsi), ani(6, 6)
!
!
! ----------------------------------------------------------------------
!     MODELE VISCOPLASTIQUE SANS SEUIL DE EDGAR
!     CALCUL DU TENSEUR EQUIVALENT AU SENS DE HILL
!     EQUI = DSQRT(TENS(I)*ANI(I,J)*TENS(J))
! IN  DIM  : DIMENSION DE L'ESPACE
! IN  TENS : TENSEUR
! IN  ANI  : MATRICE D ANISOTROPIE DE HILL
!
! OUT EQUI    : TENSEUR EQUIVALENT
! ----------------------------------------------------------------------
!
    integer :: i, j
    real(kind=8) :: equi, pdtsca(6)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    data     pdtsca/1.d0,1.d0,1.d0,2.d0,2.d0,2.d0/
!
    equi = 0.d0
    do 5 i = 1, ndimsi
        do 10 j = 1, ndimsi
            equi=equi+pdtsca(i)*tens(i)*ani(i,j)*pdtsca(j)*tens(j)
10      continue
 5  end do
!
    if (equi .gt. 0.d0) then
        equi = sqrt(equi)
    else
        if (abs(equi) .lt. r8prem()) then
            equi = 0.d0
        else
            call utmess('F', 'COMPOR1_71')
        endif
    endif
!
    edgequ = equi
!
end function
