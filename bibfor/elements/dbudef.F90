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

subroutine dbudef(depl, b, d, nbsig, nbinco,&
                  sigma)
!.======================================================================
    implicit none
!
!      DBUDEF   -- CALCUL DU VECTEUR DES CONTRAINTES AUX POINTS
!                  D'INTEGRATION SUR L'ELEMENT COURANT
!                  EN FAISANT LE PRODUIT D*B*DEPL
!
!   ARGUMENT        E/S  TYPE         ROLE
!    DEPL(1)        IN     R        VECTEUR DES DEPLACEMENTS SUR
!                                   L'ELEMENT
!    B(NBSIG,1)     IN     R        MATRICE (B) RELIANT LES
!                                   DEFORMATIONS DU PREMIER ORDRE
!                                   AUX DEPLACEMENTS AU POINT
!                                   D'INTEGRATION COURANT
!    D(NBSIG,1)     IN     R        MATRICE DE HOOKE
!    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE
!                                   A L'ELEMENT
!    NBINCO         IN     I        NOMBRE D'INCONNUES DE L'ELEMENT
!    SIGMA(1)       OUT    R        CONTRAINTES AU POINT D'INTEGRATION
!                                   COURANT
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
    real(kind=8) :: depl(1), b(nbsig, 1), d(nbsig, 1), sigma(1)
! -----  VARIABLES LOCALES
    real(kind=8) :: eps(6)
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! --- INITIALISATION :
!     ----------------
!-----------------------------------------------------------------------
    integer :: i, j, nbinco, nbsig
    real(kind=8) :: s, zero
!-----------------------------------------------------------------------
    zero = 0.0d0
!
! --- CALCUL DU VECTEUR DES COMPOSANTES DU TENSEUR DES DEFORMATIONS
! --- AU POINT D'INTEGRATION COURANT
!      -----------------------------
    do 10 i = 1, nbsig
!
        s = zero
!
        do 20 j = 1, nbinco
            s = s + depl(j)*b(i,j)
20      continue
!
        eps(i) = s
10  end do
!
! --- VECTEUR DES CONTRAINTES
!      ----------------------
    do 30 i = 1, nbsig
!
        s = zero
!
        do 40 j = 1, nbsig
            s = s + eps(j)*d(i,j)
40      continue
!
        sigma(i) = s
30  end do
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
