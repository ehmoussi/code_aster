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

function mefin1(nbz, nbgrp, imod, icyl, jmod,&
                jcyl, z, f1, f2, f3)
    implicit none
!
    integer :: nbz, nbgrp, imod, icyl, jmod, jcyl
    real(kind=8) :: z(*), f1(nbz*nbgrp, *), f2(nbz*nbgrp, *), f3(*)
!     CALCUL DE L'INTEGRALE SUR (0,L) DE F3(Z)*F1(Z)*F2(Z)
!     OU F1 EST LA DEFORMEE DU MODE (IMOD) SUR LE CYLINDRE
!     (ICYL) ET F2 CELLE DU MODE (JMOD) SUR LE CYLINDRE (JCYL)
!     OPERATEUR APPELANT : OP0144 , FLUST3, MEFIST, MEFMAT
! ----------------------------------------------------------------------
!     OPTION DE CALCUL   : CALC_FLUI_STRU , CALCUL DES PARAMETRES DE
!     COUPLAGE FLUIDE-STRUCTURE POUR UNE CONFIGURATION DE TYPE "FAISCEAU
!     DE TUBES SOUS ECOULEMENT AXIAL"
! ----------------------------------------------------------------------
! IN  : NBZ    : NOMBRE DE NOEUDS DE LA DISCRETISATION AXIALE
! IN  : NBGRP  : NOMBRE DE GROUPES D EQUIVALENCE
! IN  : IMOD   : NUMERO DU MODE POUR LA FONCTION F1
! IN  : ICYL   : INDICE DU CYLINDRE POUR LA FONCTION F1
! IN  : JMOD   : NUMERO DU MODE POUR LA FONCTION F2
! IN  : JCYL   : INDICE DU GROUPE DE CYLINDRE POUR LA FONCTION F2
! IN  : Z      : COORDONNEES 'Z' DANS LE REPERE AXIAL DES
!                POINTS DISCRETISES, IDENTIQUES POUR TOUS LES CYLINDRES
! IN  : F1     : PREMIERE FONCTION
! IN  : F2     : DEUXIEME FONCTION
! IN  : F3     : TROISIEME FONCTION
! OUT : MEFIN1 : INTEGRALE CALCULEE
! ----------------------------------------------------------------------
    real(kind=8) :: mefin1
! ----------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
    integer :: n, nbz1, nbz2
!-----------------------------------------------------------------------
    mefin1 = 0.d0
!
    nbz1 = nbz*(icyl-1)
    nbz2 = nbz*(jcyl-1)
!
    do 1 n = 1, nbz-1
        mefin1 = mefin1+0.5d0*(&
                 z(n+1)-z(n))* (f3(n+1)*f1(n+nbz1+1, imod)*f2(n+nbz2+1,jmod)+ f3(n)*f1(n+nbz1,imo&
                 &d)*f2(n+nbz2,jmod)&
                 )
 1  end do
!
end function
