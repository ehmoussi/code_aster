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

subroutine sigimc(fami, nno, ndim, nbsig, npg,&
                  ni, xyz, instan, mater, repere,&
                  epsini, sigma)
!.======================================================================
    implicit none
!
!      SIGIMC   -- CALCUL DES  CONTRAINTES INITIALES
!                  AUX POINTS D'INTEGRATION
!                  POUR LES ELEMENTS ISOPARAMETRIQUES
!
!   ARGUMENT        E/S  TYPE         ROLE
!    FAMI           IN     K4       FAMILLE DES POINTS DE GAUSS
!    NNO            IN     I        NOMBRE DE NOEUDS DE L'ELEMENT
!    NDIM           IN     I        DIMENSION DE L'ELEMENT (2 OU 3)
!    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE
!                                   A L'ELEMENT
!    NPG            IN     I        NOMBRE DE POINTS D'INTEGRATION
!                                   DE L'ELEMENT
!    NI(1)          IN     R        FONCTIONS DE FORME
!    XYZ(1)         IN     R        COORDONNEES DES CONNECTIVITES
!    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
!    MATER          IN     I        MATERIAU
!    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
!                                   D'ORTHOTROPIE
!    EPSINI(1)      IN     R        VECTEUR DES DEFORMATIONS INITIALES
!    SIGMA(1)       OUT    R        CONTRAINTES INITIALES
!                                   AUX POINTS D'INTEGRATION
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "asterfort/dmatmc.h"
    character(len=4) :: fami
    real(kind=8) :: ni(1), xyz(1), repere(7), epsini(1)
    real(kind=8) :: sigma(1), instan
! -----  VARIABLES LOCALES
    real(kind=8) :: d(36), xyzgau(3)
    character(len=2) :: k2bid
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! --- INITIALISATIONS :
!     -----------------
!-----------------------------------------------------------------------
    integer :: i, idim, igau, j, mater, nbsig, ndim
    integer :: nno, npg
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    k2bid = '  '
    zero = 0.0d0
!
    sigma(1:nbsig*npg) = zero
!
! --- CALCUL DES CONTRAINTES INITIALES :
! ---  BOUCLE SUR LES POINTS D'INTEGRATION
!      -----------------------------------
    do igau = 1, npg
!
!  --      COORDONNEES AU POINT D'INTEGRATION
!  --      COURANT
!          -------
        xyzgau(1) = zero
        xyzgau(2) = zero
        xyzgau(3) = zero
!
        do i = 1, nno
            do idim = 1, ndim
                xyzgau(idim) = xyzgau(idim) + ni(i+nno*(igau-1))*xyz( idim+ndim*(i-1))
            end do
        end do
!
!  --      CALCUL DE LA MATRICE DE HOOKE (LE MATERIAU POUVANT
!  --      ETRE ISOTROPE, ISOTROPE-TRANSVERSE OU ORTHOTROPE)
!          -------------------------------------------------
        call dmatmc(fami, mater, instan, '+',&
                    igau, 1, repere, xyzgau, nbsig,&
                    d)
!
!  --      CONTRAINTES INITIALES AU POINT D'INTEGRATION COURANT
!          ------------------------------------------------------
        do i = 1, nbsig
            do j = 1, nbsig
                sigma(i+nbsig*(igau-1)) = sigma(&
                                          i+nbsig*(igau-1)) + d(j+(i-1)*nbsig)*epsini(j+nbsig*(ig&
                                          &au-1)&
                                          )
            end do
        end do
!
    end do
end subroutine
