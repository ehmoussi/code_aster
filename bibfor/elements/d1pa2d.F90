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

subroutine d1pa2d(repere, irep, passag)
!.======================================================================
    implicit none
!
!      D1PA2D  -- CALCUL DE LA MATRICE DE PASSAGE DU REPERE
!                 D'ORTHOTROPIE AU REPERE GLOBAL POUR L'INVERSE
!                 DE LA MATRICE DE HOOKE EN 2D
!
!   ARGUMENT        E/S  TYPE         ROLE
!    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
!                                   D'ORTHOTROPIE
!    IREP           OUT    I        = 0
!                                     SI LE CHANGEMENT DE REPERE EST
!                                     TRIVIAL (I.E. PASSAG = IDENTITE)
!                                   = 1 SINON
!    PASSAG(6,6)    OUT    R        MATRICE DE PASSAGE DU REPERE
!                                   D'ORTHOTROPIE AU REPERE GLOBAL
!                                   POUR L'INVERSE DE LA MATRICE DE
!                                   HOOKE
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
    real(kind=8) :: repere(7), passag(4, 4)
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! ---- INITIALISATIONS
!      ---------------
!-----------------------------------------------------------------------
    integer :: irep
    real(kind=8) :: angl, cosa, deux, sina, un, zero
!-----------------------------------------------------------------------
    zero = 0.0d0
    un = 1.0d0
    deux = 2.0d0
    irep = 0
!
    angl = repere(2)
!
    if (angl .eq. zero) then
!
        irep = 0
    else
!
        cosa = cos(angl)
        sina = sin(angl)
        irep = 1
!
! ---- CONSTRUCTION DE LA MATRICE DE PASSAGE  POUR LE TENSEUR
! ---- D'ELASTICITE (QUI EST DU QUATRIEME ORDRE) DU REPERE
! ---- D'ORTHOTROPIE AU REPERE GLOBAL.
!       ------------------------------
!
        passag(1,1) = cosa*cosa
        passag(2,1) = sina*sina
        passag(3,1) = zero
        passag(4,1) =-cosa*sina
!
        passag(1,2) = sina*sina
        passag(2,2) = cosa*cosa
        passag(3,2) = zero
        passag(4,2) = sina*cosa
!
        passag(1,3) = zero
        passag(2,3) = zero
        passag(3,3) = un
        passag(4,3) = zero
!
        passag(1,4) = deux*sina*cosa
        passag(2,4) =-deux*sina*cosa
        passag(3,4) = zero
        passag(4,4) = cosa*cosa - sina*sina
!
    endif
!.============================ FIN DE LA ROUTINE ======================
end subroutine
