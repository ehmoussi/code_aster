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

subroutine bsigmc(nno, ndim, nbsig, npg, ipoids,&
                  ivf, idfde, xyz, nharm, sigma,&
                  bsigma)
!.======================================================================
    implicit none
!
!      BSIGMC  -- CALCUL DES FORCES INTERNES B*SIGMA AUX NOEUDS
!                 DE L'ELEMENT DUES AU CHAMP DE CONTRAINTES SIGMA
!                 DEFINI AUX POINTS D'INTEGRATION
!
!   ARGUMENT        E/S  TYPE         ROLE
!    NNO            IN     I        NOMBRE DE NOEUDS DE L'ELEMENT
!    NDIM           IN     I        DIMENSION DE L'ELEMENT (2 OU 3)
!    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE
!                                   A L'ELEMENT
!    NPG            IN     I        NOMBRE DE POINTS D'INTEGRATION
!                                   DE L'ELEMENT
!    IVF            IN     I        POINTEUR FONCTIONS DE FORME
!    IPOIDS         IN     I        POINTEUR POIDS D'INTEGRATION
!    IDFDE          IN     I        PT DERIVEES DES FONCTIONS DE FORME
!    XYZ(1)         IN     R        COORDONNEES DES CONNECTIVITES
!    NHARM          IN     R        NUMERO D'HARMONIQUE
!    SIGMA(1)       IN     R        CONTRAINTES AUX POINTS D'INTEGRATION
!    BSIGMA(1)      OUT    R        VECTEUR DES FORCES INTERNES
!                                   BT*SIGMA AUX NOEUDS DE L'ELEMENT
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "asterfort/bmatmc.h"
#include "asterfort/btsig.h"
    real(kind=8) :: xyz(1), sigma(1), bsigma(1), nharm
! -----  VARIABLES LOCALES
    real(kind=8) :: b(486), jacgau
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! --- INITIALISATIONS :
!     -----------------
!-----------------------------------------------------------------------
    integer :: i, idfde, igau, ipoids, ivf, nbinco, nbsig
    integer :: ndim, nno, npg
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    zero = 0.0d0
    nbinco = ndim*nno
!
    do 10 i = 1, nbinco
        bsigma(i) = zero
10  end do
!
! --- CALCUL DE SOMME_ELEMENT(BT_SIGMA) :
! ---  BOUCLE SUR LES POINTS D'INTEGRATION
!      -----------------------------------
    do 20 igau = 1, npg
!
!  --      CALCUL DE LA MATRICE B RELIANT LES DEFORMATIONS DU
!  --      PREMIER ORDRE AUX DEPLACEMENTS AU POINT D'INTEGRATION
!  --      COURANT : (EPS_1) = (B)*(UN)
!          ----------------------------
        call bmatmc(igau, nbsig, xyz, ipoids, ivf,&
                    idfde, nno, nharm, jacgau, b)
!
!  --      CALCUL DU PRODUIT (BT)*(SIGMA)*JACOBIEN*POIDS
!          ---------------------------------------------
        call btsig(nbinco, nbsig, jacgau, b, sigma(1+nbsig*(igau-1)),&
                   bsigma)
20  end do
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
