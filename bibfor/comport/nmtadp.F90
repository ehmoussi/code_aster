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

subroutine nmtadp(ndimsi, crit, mat, sigel, vim,&
                  epm, dp, sp, xi, g,&
                  iret)
!
    implicit none
#include "asterfort/assert.h"
#include "asterfort/nmtacr.h"
#include "asterfort/utmess.h"
#include "asterfort/zeroco.h"
    integer :: ndimsi, iret
    real(kind=8) :: crit(3), mat(14), sigel(*), vim(9), epm(*), sp, xi
    real(kind=8) :: dp, g
! ----------------------------------------------------------------------
! TAHERI :  RESOLUTION DE L'EQUATION SCALAIRE G(P,SP,XI) = 0 PAR RT A SP
! ----------------------------------------------------------------------
! IN  NDIMSI DIMENSION DES TENSEURS
! IN  CRIT   CRITERES DE CONVERGENCE LOCAUX
! IN  MAT    TABLEAU DES CONSTANTES MATERIAUX
! IN  SIGEL  DEVIATEUR DES CONTRAINTES ELASTIQUES
! IN  VIM    VARIABLES INTERNES EN T-
! IN  EPM    DEFORMATION PLASTIQUE EN T-
! OUT DP     INCREMENT DEFORMATION PLASTIQUE CUMULEE TQ  F(P,SP,XI) = 0
! IN  SP     CONTRAINTE DE PIC
! IN  XI     PILOTAGE DE EPN
! OUT G      VALEUR DU CRITERE                   G(P,SP,XI)
! OUT IRET   CODE RETOUR DE L'INTEGRATION DE LA LOI DE TAHERI
!               IRET=0 => PAS DE PROBLEME
!               IRET=1 => ABSENCE DE CONVERGENCE
! ----------------------------------------------------------------------
!
    integer :: niter
    real(kind=8) :: f, fds, gds, fdp, gdp, fdx, gdx, dpmax, sig(6), tang(6, 6)
    real(kind=8) :: x(4), y(4), gg(4)
!
!
!    EXAMEN DE LA SOLUTION DP = 0
!
    dp = 0.d0
    call nmtacr(1, ndimsi, mat, sigel, vim,&
                epm, dp, sp, xi, f,&
                g, fds, gds, fdp, gdp,&
                fdx, gdx, dpmax, sig, tang)
!
    ASSERT(f.gt.0.d0)
!
    x(2) = dp
    y(2) = f
    gg(2) = g
!
!    EXAMEN DE LA SOLUTION DP = DPMAX
!
    call nmtacr(0, ndimsi, mat, sigel, vim,&
                epm, dp, sp, xi, f,&
                g, fds, gds, fdp, gdp,&
                fdx, gdx, dpmax, sig, tang)
    dp = dpmax
    call nmtacr(1, ndimsi, mat, sigel, vim,&
                epm, dp, sp, xi, f,&
                g, fds, gds, fdp, gdp,&
                fdx, gdx, dpmax, sig, tang)
    if (f .gt. 0.d0) then
        call utmess('F', 'ALGORITH8_31')
    endif
    x(1) = dp
    y(1) = f
    gg(1) = g
!
!    CALCUL DE DP : EQUATION SCALAIRE F=0 AVEC  0 < DP < DPMAX
!
    x(3) = x(1)
    y(3) = y(1)
    gg(3) = gg(1)
    x(4) = x(2)
    y(4) = y(2)
    gg(4) = gg(2)
!
    do 100 niter = 1, int(crit(1))
        if (abs(y(4))/mat(4) .lt. crit(3) .and. x(4) .ne. 0.d0) goto 110
        call zeroco(x, y)
        call nmtacr(1, ndimsi, mat, sigel, vim,&
                    epm, x(4), sp, xi, y(4),&
                    gg(4), fds, gds, fdp, gdp,&
                    fdx, gdx, dpmax, sig, tang)
100  end do
    iret = 1
    goto 9999
110  continue
    dp = x(4)
    g = gg(4)
!
9999  continue
end subroutine
