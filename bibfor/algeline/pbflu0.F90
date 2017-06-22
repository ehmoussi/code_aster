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

subroutine pbflu0(rhof, hmoy, rmoy, long, icoq,&
                  imod, nbm, rkip, tcoef, d)
    implicit none
#include "asterfort/utmess.h"
! COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
! RESOLUTION DU PROBLEME FLUIDE INSTATIONNAIRE DANS LE CAS PARTICULIER
! OU UMOY = 0
! APPELANT : PBFLUI
!-----------------------------------------------------------------------
!  IN : RHOF   : MASSE VOLUMIQUE DU FLUIDE
!  IN : HMOY   : JEU ANNULAIRE MOYEN
!  IN : RMOY   : RAYON MOYEN
!  IN : LONG   : LONGUEUR DU DOMAINE DE RECOUVREMENT DES DEUX COQUES
!  IN : ICOQ   : INDICE CARACTERISANT LA COQUE SUR LAQUELLE ON TRAVAILLE
!                ICOQ=1 COQUE INTERNE  ICOQ=2 COQUE EXTERNE
!  IN : IMOD   : INDICE DU MODE CONSIDERE
!  IN : NBM    : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
!  IN : RKIP   : ORDRE DE COQUE DU MODE CONSIDERE, PONDERE PAR LA VALEUR
!                MOYENNE DU PROFIL DE PRESSION
!  IN : TCOEF  : TABLEAU DES COEFFICIENTS DES DEFORMEES AXIALES
! OUT : D      : COEFFICIENTS DE LA COMBINAISON LINEAIRE DONNANT LA
!                PRESSION PERTURBEE (DECOMPOSITION SUR UNE FAMILLE
!                DE FONCTIONS EXPONENTIELLES REELLES ET COMPLEXES)
!                LORSQUE UMOY = 0
!-----------------------------------------------------------------------
!
    real(kind=8) :: rhof, hmoy, rmoy, long
    integer :: icoq, imod, nbm
    real(kind=8) :: rkip, tcoef(10, nbm), d(6)
!
    real(kind=8) :: ln
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: itab
    real(kind=8) :: a1, a2, a3, a4, b1, b2, b3
    real(kind=8) :: b4, c1, c2, c3, c4, poids, tole
    real(kind=8) :: u, v, vi1, vi2, x, y, z
!
!-----------------------------------------------------------------------
    tole = 1.d-6
    itab = 0
    poids = -1.d0
    if (icoq .eq. 2) then
        itab = 5
        poids = 1.d0
    endif
    ln = tcoef(1+itab,imod)
    a1 = tcoef(2+itab,imod) * poids
    a2 = tcoef(3+itab,imod) * poids
    a3 = tcoef(4+itab,imod) * poids
    a4 = tcoef(5+itab,imod) * poids
    b1 = tcoef(2+itab,imod) / 2.d0
    b2 = tcoef(3+itab,imod) / 2.d0
    b3 = tcoef(4+itab,imod) / 2.d0
    b4 = tcoef(5+itab,imod) / 2.d0
    c1 = a1/hmoy + b1/rmoy
    c2 = a2/hmoy + b2/rmoy
    c3 = a3/hmoy + b3/rmoy
    c4 = a4/hmoy + b4/rmoy
!
    u = -1.d0*rhof*(rkip**2)
    v = (ln/long)**2 + (rkip/rmoy)**2
!
    d(1) = u*c1/v
    d(2) = u*c2/v
!
    v = -1.d0*(ln/long)**2 + (rkip/rmoy)**2
    if (dble(abs(v)) .lt. tole) then
        call utmess('F', 'ALGELINE3_18')
    endif
    d(3) = u*c3/v
    d(4) = u*c4/v
!
    vi1 = d(1) + d(3)
    vi2 = d(1)*dble(cos(ln)) + d(2)*dble(sin(ln)) + d(3)*dble(cosh(ln)) + d(4)*dble(sinh(ln))
    x = -1.d0*rkip*long/rmoy
    y = dble(exp(x))
    z = 1.d0/(1.d0-y*y)
    d(5) = z * (vi1*y-vi2)
    d(6) = z * (vi2*y-vi1)
!
end subroutine
