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

subroutine ortloc(dsidep, i1, j1, r)
    implicit none
#include "asterfort/utbtab.h"
    real(kind=8) :: trav(3, 3), xab(3, 3), dsidep(6, 6), r(9)
    integer :: i, j, i1, j1
!       PASSAGE DE LA MATRICE TANGENTE DU REPERE D'ORTHOTROPIE AU REPERE
!       LOCAL DE L'ELEMENT. CE PASSAGE SE FAIT PAR SOUS MATRICES
!
!       IN      DSIDEP = MATRICE TANGENTE
!               R      = MATRICE DE CHANGEMENT DE REPERE
!       OUT     DSIDEP = MATRICE TANGENTE
!-----------------------------------------------------------------------
!
    do 10 i = 1, 3
        do 20 j = 1, 3
            trav(i,j) = dsidep(i+i1,j+j1)
20      continue
10  end do
!
    call utbtab('ZERO', 3, 3, trav, r,&
                xab, trav)
!
    do 30 i = 1, 3
        do 40 j = 1, 3
            dsidep(i+i1,j+j1) = trav(i,j)
40      continue
30  end do
!
end subroutine
