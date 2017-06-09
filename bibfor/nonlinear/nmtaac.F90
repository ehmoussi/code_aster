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

subroutine nmtaac(type, ndimsi, mat, sigel, vim,&
                  epm, dp, sp, xi, sigp,&
                  vip)
!
!
    implicit none
#include "asterfort/nmtacr.h"
    integer :: ndimsi, type
    real(kind=8) :: mat(14), sigel(ndimsi), vim(9), epm(ndimsi), dp, sp, xi
    real(kind=8) :: sigp(ndimsi), vip(9)
!
! ----------------------------------------------------------------------
!  TAHERI : ACTUALISATION DES VARIABLES INTERNES ET DES CONTRAINTES
! ----------------------------------------------------------------------
! IN  TYPE   0: ELAS, 1:PSEUDO-ELAS, 2: PLAS, 3: PLAS+G
! IN  NDIMSI DIMENSION DES TENSEURS
! IN  SIGEL  DEVIATEUR DES CONTRAINTES ELASTIQUES
! IN  VIM    VARIABLES INTERNES EN T-
! IN  EPM    DEFORMATION PLASTIQUE EN T-
! IN  DP     INCREMENT DE DEFORMATION PLASTIQUE CUMULEE
! IN  SP     CONTRAINTE DE PIC
! IN  XI     PILOTAGE DE EPN
! VAR SIGP   CONTRAINTE EN T+
! OUT VIP    VARIABLES INTERNES EN T+
! ----------------------------------------------------------------------
!
    integer :: k
    real(kind=8) :: sig(6)
    real(kind=8) :: f, g, fdp, gdp, fds, gds, fdx, gdx, dpmax, tang(6, 6)
!
!
!    ACTUALISATION DES CONTRAINTES
    if (type .ge. 2) then
        call nmtacr(4, ndimsi, mat, sigel, vim,&
                    epm, dp, sp, xi, f,&
                    g, fds, gds, fdp, gdp,&
                    fdx, gdx, dpmax, sig, tang)
        do 5 k = 1, ndimsi
            sigp(k) = sigp(k) - sig(k)
 5      continue
    endif
!
!
!    ACTUALISATION DES VARIABLES INTERNES
    vip(1) = vim(1) + dp
    vip(2) = sp
    do 10 k = 1, ndimsi
        vip(k+2) = epm(k) - xi * (epm(k) - vim(k+2))
10  end do
    vip(9) = type
!
!
end subroutine
