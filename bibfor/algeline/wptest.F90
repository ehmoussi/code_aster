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

subroutine wptest(exclu, xh, xb, vp, neq,&
                  nmax)
    implicit none
!
    complex(kind=8) :: vp, xh(*), xb(*)
    integer :: neq, exclu(*)
    real(kind=8) :: nmax
!
!     TEST SUR LE COUPLAGE HAUT-BAS DU PB GENERALISE ASSOCIE AU PB
!     QUADRATIQUE POUR CHOISIR LA VALEUR PROPRE QUADRATIQUE RACINE
!     D' UNE EQUATION DE SECOND DEGRE (CF WP2VEC)
!
!              NMAX := !! M*XB - VP*M*XH !!
!     -----------------------------------------------------------------
! IN  XH   : C : PARTIE HAUTE D' UN VECTEUR PROPRE DU PB QUAD
! IN  XB   : C : PARTIE BASSE D' UN VECTEUR PROPRE DU PB QUAD
! IN  VP   : C : VALEUR CANDIDATE A LA PROPRETE
! IN  NEQ  : I : TAILLE DES VECTEURS DU PB QUADRATIQUE
! OUT NMAX : R : NORME MAX DU COUPLAGE
!     -----------------------------------------------------------------
    integer :: i
    real(kind=8) :: a
!     -----------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    nmax = -1.0d-50
!
!     --- TEST SUR LA PARTIE BASSE : COUPLAGE ----
!
!-DEB
!
!     /* CE QUI SUIT MARCHE POUR UNE MATRICE DE MASSE GENERALE */
!
!     CALL MRMULT('ZERO',LMASSE,XH,'C',V1,1)
!     CALL MRMULT('ZERO',LMASSE,XB,'C',V2,1)
!
!     DO 10, I = 1, NEQ, 1
!        A    = ABS(VP*V1(I)-V2(I))
!        NMAX = MAX(A,NMAX)
!10    CONTINUE
!
!-FIN
!
!     /* CE QUI SUIT MARCHE POUR UNE MATRICE DE MASSE      */
!     /* AVEC DECOMPOSITION BLOC CONFORME A LA DOC DE REF */
!     /* I.E : BLOCS ASSOCIES AUX DDL LAGR A ZERO         */
!
    do 20, i = 1, neq, 1
    a = abs(vp*xh(i)-xb(i))*exclu(i)
    nmax = max(a,nmax)
    20 end do
!
end subroutine
