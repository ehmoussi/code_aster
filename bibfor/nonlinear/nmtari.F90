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

subroutine nmtari(type, ndimsi, mat, sigel, vim,&
                  epm, dp, sp, xi, dsidep)
!
!
    implicit none
#include "asterfort/matini.h"
#include "asterfort/nmtacr.h"
    integer :: ndimsi, type
    real(kind=8) :: mat(14), sigel(ndimsi), vim(9), epm(ndimsi), dp, sp, xi
    real(kind=8) :: dsidep(6, 6)
!
! ----------------------------------------------------------------------
!  TAHERI : CALCUL DE LA RIGIDITE TANGENTE
! ----------------------------------------------------------------------
! IN  TYPE   0: ELAS, 1:PSEUDO-ELAS, 2: PLAS, 3: PLAS+G
! IN  NDIMSI DIMENSION DES TENSEURS
! IN  SIGEL  DEVIATEUR DES CONTRAINTES ELASTIQUES
! IN  VIM    VARIABLES INTERNES EN T-
! IN  EPM    DEFORMATION PLASTIQUE EN T-
! IN  DP     INCREMENT DE DEFORMATION PLASTIQUE CUMULEE
! IN  SP     CONTRAINTE DE PIC
! IN  XI     PILOTAGE DE EPN
! OUT DSIDEP MATRICE TANGENTE
! ----------------------------------------------------------------------
!
    integer :: i, j, mode
    real(kind=8) :: tmp
    real(kind=8) :: tang(6, 6)
    real(kind=8) :: f, g, fdp, gdp, fds, gds, fdx, gdx, dpmax, sig(6)
!
!
!    MATRICE ELASTIQUE
!
    call matini(6, 6, 0.d0, dsidep)
!
    tmp = (mat(1) - mat(2)) / 3.d0
    do 30 i = 1, 3
        do 40 j = 1, 3
            dsidep(i,j) = tmp
40      continue
30  end do
!
    do 50 i = 1, ndimsi
        dsidep(i,i) = dsidep(i,i) + mat(2)
50  end do
!
!
!    CONTRIBUTION NON LINEAIRE SYMETRISEE
!
    if (type .ge. 2) then
        if (type .eq. 2) mode = 5
        if (type .eq. 3) mode = 6
        call nmtacr(mode, ndimsi, mat, sigel, vim,&
                    epm, dp, sp, xi, f,&
                    g, fds, gds, fdp, gdp,&
                    fdx, gdx, dpmax, sig, tang)
        do 60 i = 1, ndimsi
            do 70 j = 1, ndimsi
                dsidep(i,j)=dsidep(i,j)-mat(2)**2*(tang(i,j)+tang(j,i)&
                )/2.d0
70          continue
60      continue
    endif
!
!
end subroutine
