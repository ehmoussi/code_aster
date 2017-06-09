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

subroutine nmtasp(ndimsi, crit, mat, sigel, vim,&
                  epm, dp, sp, xi, f,&
                  iret)
!
    implicit none
#include "asterfort/nmtacr.h"
#include "asterfort/zeroco.h"
    integer :: ndimsi
    real(kind=8) :: crit(3), mat(14), sigel(*), vim(9), epm(*), dp, xi
    real(kind=8) :: sp, f
! ----------------------------------------------------------------------
! TAHERI :  RESOLUTION DE L'EQUATION SCALAIRE G(P,SP,XI) = 0 PAR RT A SP
! ----------------------------------------------------------------------
! IN  NDIMSI DIMENSION DES TENSEURS
! IN  CRIT   CRITERES DE CONVERGENCE LOCAUX
! IN  MAT    TABLEAU DES CONSTANTES MATERIAUX
! IN  SIGEL  DEVIATEUR DES CONTRAINTES ELASTIQUES
! IN  VIM    VARIABLES INTERNES EN T-
! IN  EPM    DEFORMATION PLASTIQUE EN T-
! IN  DP     INCREMENT DE DEFORMATION PLASTIQUE CUMULEE
! OUT SP     CONTRAINTE DE PIC (SIGMA P) TEL QUE G(P,SP,XI)=0
! IN  XI     PILOTAGE DE EPN
! OUT F      VALEUR DU CRITERE DE PLASTICITE     F(P,SP,XI)
! OUT IRET   CODE RETOUR DE LA RESOLUTION DE L'EQUATION SCALAIRE
!               IRET=0 => PAS DE PROBLEME
!               IRET=1 => ECHEC
! ----------------------------------------------------------------------
!
    integer :: niter, iret
    real(kind=8) :: g, fds, gds, fdp, gdp, fdx, gdx, dpmax, sig(6), tang(6, 6)
    real(kind=8) :: x(4), y(4), ff(4)

    iret = 0
!
!
!    EXAMEN DE LA SOLUTION SP = SP-
!
    sp = vim(2)
    call nmtacr(1, ndimsi, mat, sigel, vim,&
                epm, dp, sp, xi, f,&
                g, fds, gds, fdp, gdp,&
                fdx, gdx, dpmax, sig, tang)
    if (g .lt. mat(4)*crit(3)) goto 9999
    x(2) = sp
    y(2) = g
    ff(2) = f
!
!    EXAMEN DE LA SOLUTION SP = S
!
    sp = mat(11)
    call nmtacr(1, ndimsi, mat, sigel, vim,&
                epm, dp, sp, xi, f,&
                g, fds, gds, fdp, gdp,&
                fdx, gdx, dpmax, sig, tang)
    if (g .gt. -mat(4)*crit(3)) goto 9999
    x(1) = mat(11)
    y(1) = g
    ff(1) = f
!
!    CALCUL DE SP : EQUATION SCALAIRE G=0 AVEC  SP- < SP < S
!
    x(3) = x(1)
    y(3) = y(1)
    ff(3) = ff(1)
    x(4) = x(2)
    y(4) = y(2)
    ff(4) = ff(2)
!
    do 100 niter = 1, int(crit(1))
        if (abs(y(4)) .lt. mat(4)*crit(3)) goto 110
        call zeroco(x, y)
        call nmtacr(1, ndimsi, mat, sigel, vim,&
                    epm, dp, x(4), xi, ff(4),&
                    y(4), fds, gds, fdp, gdp,&
                    fdx, gdx, dpmax, sig, tang)
100  end do
    iret = 1
    goto 9999
110  continue
    sp = x(4)
    f = ff(4)
!
9999  continue
end subroutine
