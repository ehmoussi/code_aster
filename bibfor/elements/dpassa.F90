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

subroutine dpassa(xyzgau, repere, irep, passag)
!.======================================================================
    implicit none
!
!      DPASSA  -- CALCUL DE LA MATRICE DE PASSAGE DU REPERE
!                 D'ORTHOTROPIE AU REPERE GLOBAL POUR LE
!                 TENSEUR D'ELASTICITE
!                 CETTE MATRICE EST CONSTRUITE EN PARTANT
!                 DE LA CONSIDERATION QUE L'ENERGIE DE DEFORMATION
!                 EXPRIMEE DANS LE REPERE GLOBAL EST EGALE A
!                 L'ENERGIE DE DEFORMATION EXPRIMEE DANS LE REPERE
!                 D'ORTHOTROPIE
!
!   ARGUMENT        E/S  TYPE         ROLE
!    XYZGAU(3)      IN     R        COORDONNEES DU POINT D'INTEGRATION
!                                   COURANT
!    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
!                                   D'ORTHOTROPIE
!    IREP           OUT    I        = 0
!                                     SI LE CHANGEMENT DE REPERE EST
!                                     TRIVIAL (I.E. PASSAG = IDENTITE)
!                                   = 1 SINON
!    PASSAG(6,6)    OUT    R        MATRICE DE PASSAGE DU REPERE
!                                   D'ORTHOTROPIE AU REPERE GLOBAL
!                                   POUR LE TENSEUR D'ELASTICITE
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "asterfort/matrot.h"
#include "asterfort/utrcyl.h"
    real(kind=8) :: repere(7), xyzgau(3), passag(6, 6)
! -----  VARIABLES LOCALES
    real(kind=8) :: angl(3), p(3, 3), dire(3), orig(3)
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! ---- INITIALISATIONS
!      ---------------
!-----------------------------------------------------------------------
    integer :: i, irep, j
    real(kind=8) :: deux, zero
!-----------------------------------------------------------------------
    zero = 0.0d0
    deux = 2.0d0
    irep = 0
!
    do 10 i = 1, 3
        do 10 j = 1, 3
            p(i,j) = zero
10      continue
!
! ---- CAS OU LE REPERE D'ORTHOTROPIE EST DEFINI PAR 3 ANGLES NAUTIQUES
!      ----------------------------------------------------------------
    if (repere(1) .gt. zero) then
!
        angl(1) = repere(2)
        angl(2) = repere(3)
        angl(3) = repere(4)
!
        if (angl(1) .eq. zero .and. angl(2) .eq. zero .and. angl(3) .eq. zero) then
            irep = 0
        else
!
! ----     CONSTRUCTION DE LA MATRICE DE PASSAGE (POUR DES VECTEURS)
! ----     DU REPERE D'ORTHOTROPIE AU REPERE GLOBAL
!          ----------------------------------------
            call matrot(angl, p)
            irep = 1
        endif
!
! ---- CAS OU LE REPERE D'ORTHOTROPIE EST DEFINI COMME SUIT :
! ----    LA DIRECTION D'ORTHOTROPIE EST DEFINIE PAR 2 ANGLES
! ----    CETTE DIRECTION EST EN OUTRE CELLE D'UN AXE AUTOUR DUQUEL
! ----    LA PARTIE DE LA STRUCTURE CONSIDEREE EST AXISYMETRIQUE,
! ----    CET AXE EST DEFINI PAR LA DONNEE SUPPLEMENTAIRE D'UN POINT
! ----    QUI LUI APPARTIENT
!      ----------------------------------------------------------------
    else
!
        dire(1) = repere(2)
        dire(2) = repere(3)
        dire(3) = repere(4)
!
        orig(1) = repere(5)
        orig(2) = repere(6)
        orig(3) = repere(7)
!
! ---- CONSTRUCTION DE LA MATRICE DE PASSAGE (POUR DES VECTEURS)
! ---- DU REPERE D'ORTHOTROPIE AU REPERE GLOBAL
!      ----------------------------------------
        call utrcyl(xyzgau, dire, orig, p)
        irep = 1
    endif
!
! ---- CONSTRUCTION DE LA MATRICE DE PASSAGE  POUR LE TENSEUR
! ---- D'ELASTICITE (QUI EST DU QUATRIEME ORDRE) DU REPERE
! ---- D'ORTHOTROPIE AU REPERE GLOBAL.
! ---- CETTE MATRICE EST CONSTRUITE EN PARTANT DE LA CONSIDERATION QUE
! ----  (SIGMA_GLOB):(EPSILON_GLOB) = (SIGMA_ORTH):(EPSILON_ORTH)
!       ---------------------------------------------------------
    if (irep .eq. 1) then
!
        passag(1,1) = p(1,1)*p(1,1)
        passag(1,2) = p(1,2)*p(1,2)
        passag(1,3) = p(1,3)*p(1,3)
        passag(1,4) = p(1,1)*p(1,2)
        passag(1,5) = p(1,1)*p(1,3)
        passag(1,6) = p(1,2)*p(1,3)
!
        passag(2,1) = p(2,1)*p(2,1)
        passag(2,2) = p(2,2)*p(2,2)
        passag(2,3) = p(2,3)*p(2,3)
        passag(2,4) = p(2,1)*p(2,2)
        passag(2,5) = p(2,1)*p(2,3)
        passag(2,6) = p(2,2)*p(2,3)
!
        passag(3,1) = p(3,1)*p(3,1)
        passag(3,2) = p(3,2)*p(3,2)
        passag(3,3) = p(3,3)*p(3,3)
        passag(3,4) = p(3,1)*p(3,2)
        passag(3,5) = p(3,1)*p(3,3)
        passag(3,6) = p(3,2)*p(3,3)
!
        passag(4,1) = deux*p(1,1)*p(2,1)
        passag(4,2) = deux*p(1,2)*p(2,2)
        passag(4,3) = deux*p(1,3)*p(2,3)
        passag(4,4) = (p(1,1)*p(2,2) + p(1,2)*p(2,1))
        passag(4,5) = (p(1,1)*p(2,3) + p(1,3)*p(2,1))
        passag(4,6) = (p(1,2)*p(2,3) + p(1,3)*p(2,2))
!
        passag(5,1) = deux*p(1,1)*p(3,1)
        passag(5,2) = deux*p(1,2)*p(3,2)
        passag(5,3) = deux*p(1,3)*p(3,3)
        passag(5,4) = p(1,1)*p(3,2) + p(1,2)*p(3,1)
        passag(5,5) = p(1,1)*p(3,3) + p(1,3)*p(3,1)
        passag(5,6) = p(1,2)*p(3,3) + p(1,3)*p(3,2)
!
        passag(6,1) = deux*p(2,1)*p(3,1)
        passag(6,2) = deux*p(2,2)*p(3,2)
        passag(6,3) = deux*p(2,3)*p(3,3)
        passag(6,4) = p(2,1)*p(3,2) + p(2,2)*p(3,1)
        passag(6,5) = p(2,1)*p(3,3) + p(2,3)*p(3,1)
        passag(6,6) = p(2,2)*p(3,3) + p(3,2)*p(2,3)
!
    endif
!.============================ FIN DE LA ROUTINE ======================
end subroutine
