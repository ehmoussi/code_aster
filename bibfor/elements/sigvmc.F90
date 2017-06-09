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

subroutine sigvmc(fami, nno, ndim, nbsig, npg,&
                  ipoids, ivf, idfde, xyz, depl,&
                  instan, repere, mater, nharm, sigma)
!.======================================================================
    implicit none
!
!      SIGVMC   -- CALCUL DES  CONTRAINTES 'VRAIES'
!                  (I.E. SIGMA_MECA - SIGMA_THERMIQUES- SIGMA_RETRAIT)
!                  AUX POINTS D'INTEGRATION POUR LES ELEMENTS
!                  ISOPARAMETRIQUES
!
!   ARGUMENT        E/S  TYPE         ROLE
!    FAMI           IN     K        FAMILLE DE POINT DE GAUSS
!    NNO            IN     I        NOMBRE DE NOEUDS DE L'ELEMENT
!    NDIM           IN     I        DIMENSION DE L'ELEMENT (2 OU 3)
!    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE
!                                   A L'ELEMENT
!    NPG            IN     I        NOMBRE DE POINTS D'INTEGRATION
!                                   DE L'ELEMENT
!    NI(1)          IN     R        FONCTIONS DE FORME
!    DNIDX(1)       IN     R        DERIVEES DES FONCTIONS DE FORME
!                                   / X SUR L'ELEMENT DE REFERENCE
!    DNIDY(1)       IN     R        DERIVEES DES FONCTIONS DE FORME
!                                   / Y SUR L'ELEMENT DE REFERENCE
!    DNIDZ(1)       IN     R        DERIVEES DES FONCTIONS DE FORME
!                                   / Z SUR L'ELEMENT DE REFERENCE
!    POIDS(1)       IN     R        POIDS D'INTEGRATION
!    XYZ(1)         IN     R        COORDONNEES DES CONNECTIVITES
!    DEPL(1)        IN     R        VECTEUR DES DEPLACEMENTS SUR
!                                   L'ELEMENT
!    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
!    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
!                                   D'ORTHOTROPIE
!    MATER          IN     I        MATERIAU
!    NHARM          IN     R        NUMERO D'HARMONIQUE
!    SIGMA(1)       OUT    R        CONTRAINTES AUX POINTS D'INTEGRATION
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterfort/sigmmc.h"
#include "asterfort/sigtmc.h"
    character(len=*) :: fami
    real(kind=8) :: xyz(1), depl(1), repere(7), sigma(1)
    real(kind=8) :: instan, nharm
    integer :: ipoids, ivf, idfde
! -----  VARIABLES LOCALES
    character(len=16) :: option
    real(kind=8) :: sigth(162), sighy(162), sigse(162)
!
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! --- INITIALISATIONS :
!     -----------------
!-----------------------------------------------------------------------
    integer :: i, mater, nbsig, ndim, nno, npg
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    zero = 0.0d0
!
    do 10 i = 1, nbsig*npg
        sigma(i) = zero
10  end do
!
!
! --- CALCUL DES CONTRAINTES MECANIQUES AUX POINTS D'INTEGRATION
!      ---------------------------------------------------------
    call sigmmc(fami, nno, ndim, nbsig, npg,&
                ipoids, ivf, idfde, xyz, depl,&
                instan, repere, mater, nharm, sigma)
!
! --- CALCUL DES CONTRAINTES THERMIQUES AUX POINTS D'INTEGRATION
!      ---------------------------------------------------------
    option = 'CALC_CONT_TEMP_R'
    call sigtmc(fami, nno, ndim, nbsig, npg,&
                zr(ivf), xyz, instan, mater, repere,&
                option, sigth)
!
!--- CALCUL DES CONTRAINTES DUES AUX RETRAIT DE DESSICCATION
!           ET D'HYDRATATION
!      ---------------------------------------------------------
!
    option = 'CALC_CONT_HYDR_R'
    call sigtmc(fami, nno, ndim, nbsig, npg,&
                zr(ivf), xyz, instan, mater, repere,&
                option, sighy)
!
!
    option = 'CALC_CONT_SECH_R'
    call sigtmc(fami, nno, ndim, nbsig, npg,&
                zr(ivf), xyz, instan, mater, repere,&
                option, sigse)
!
! --- CALCUL DES CONTRAINTES TOTALES AUX POINTS D'INTEGRATION
!      ---------------------------------------------------------
    do 20 i = 1, nbsig*npg
        sigma(i) = sigma(i) - sigth(i) - sighy(i) - sigse(i)
20  end do
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
