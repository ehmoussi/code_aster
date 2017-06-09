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

subroutine d1crit(zimat, nmnbn, nmplas, nmdpla, nmprox,&
                  cnbn, cplas, rpara, cief, cdeps,&
                  cdtg, cier, cdepsp, dc, bend)
    implicit  none
!
!     CALCUL DU MULTIPLICATEUR PLASTIQUE
!     ET DE L INCREMENT DE COURBURE PLASTIQUE
!     DANS LE CAS OU 1 CRITERE PLASTIQUE EST ACTIVE
!     METHODE EXPLICITE (PREMIER ORDRE)
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  NMNBN : FORCE - BACKFORCE
! IN  NMPLAS : MOMENTS LIMITES DE PLASTICITE
! IN  NMDPLA : DERIVEES DES MOMENTS LIMITES DE PLASTICITE
! IN  NMPROX : NMPROX > 0 : NBN DANS ZONE DE CRITIQUE
! IN  CDTG : MATRICE TANGENTE
! IN  DC : MATRICE ELASTIQUE + CONSTANTES DE PRAGER
! IN  BEND : FLEXION POSITIVE (1) OU NEGATIVE (-1)
!
! IN/OUT RPARA : LISTES DE PARAMETRES DE TYPE ENTIER
!
! OUT CNBN : NOUVELLE FORCE - BACKFORCE
! OUT CPLAS : NOUVEAUX MOMENTS LIMITES DE PLASTICITE
! OUT CIEF : NOUVEAU CIEF > 0 : NBN HORS DE LA ZONE DE DEFINITION DE MP
! OUT CDEPS : NOUVEL INCREMENT DE DEFORMATION DANS LE REPERE ORTHO
! OUT CIER : NOUVEAU CODE ERREUR
! OUT CDEPSP : NOUVEL INCREMENT DE DEF PLASTIQUE DANS LE REPERE ORTHO
!
#include "asterfort/dfplgl.h"
#include "asterfort/dfuuss.h"
#include "asterfort/fplass.h"
#include "asterfort/matmul.h"
#include "asterfort/nmnet1.h"
    integer :: bend, j, zimat, nmprox(2), cief, cier
!
    real(kind=8) :: nmnbn(6), nmplas(2, 3), nmdpla(2, 2)
    real(kind=8) :: cnbn(6), cplas(2, 3), czef, czeg, cdeps(6)
    real(kind=8) :: cdtg(6, 6), cdepsp(6), dc(6, 6), cp(6), normm
    real(kind=8) :: lambda, df(6), tdf(1, 6), a(1), b(1), dfu(6)
    real(kind=8) :: rpara(3)
!
    czef = rpara(1)
    czeg = rpara(2)
    normm = rpara(3)
!
!     CALCUL LE GRADIENT DU CRITERE DE PLASICITE
    call dfplgl(nmnbn, nmplas, nmdpla, bend, df)
!
    do 10, j = 1,6
    tdf(1,j) = df(j)
    10 end do
!
!     CALUL DES DIRECTIONS DE L ECOULEMENT DES DEFORMATIONS PLASTIQUES
    call dfuuss(nmnbn, nmplas, nmdpla, nmprox, bend,&
                dfu)
!
    call matmul(cdtg, cdeps, 6, 6, 1,&
                cp)
    call matmul(tdf, cp, 1, 6, 1,&
                a)
    call matmul(dc, dfu, 6, 6, 1,&
                cp)
    call matmul(tdf, cp, 1, 6, 1,&
                b)
!
!     CALCUL DU MULTIPLICATEUR PLASTIQUE
    lambda = (fplass(nmnbn,nmplas,bend) + a(1)) / b(1)
!
    do 20, j = 1,6
    cdepsp(j) = lambda * dfu(j)
    20 end do
!
!     CALCUL DE CNBN ET CDEPSP QUAND UN CRITERE PLASTIQUE EST ACTIVE
    call nmnet1(zimat, nmnbn, cnbn, cplas, czef,&
                czeg, cief, cdeps, cdtg, cier,&
                cdepsp, dc, normm)
!
    rpara(1) = czef
    rpara(2) = czeg
    rpara(3) = normm
!
end subroutine
