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

subroutine ante2d(itria, xbar, ksi1, ksi2)
    implicit none
!  DESCRIPTION : DETERMINATION DE L'ANTECEDENT DANS L'ELEMENT DE
!  -----------   REFERENCE D'UN POINT APPARTENANT A UN ELEMENT REEL
!                LES ELEMENTS CONSIDERES SONT DES ELEMENTS 2D TRIANGLES
!                OU QUADRANGLES
!
!                APPELANT : RECI2D
!
!  IN     : ITRIA  : INTEGER , SCALAIRE
!                    INDICATEUR DU SOUS-DOMAINE AUQUEL APPARTIENT LE
!                    POINT DE L'ELEMENT REEL :
!                    ITRIA = 1 : TRIANGLE 1-2-3
!                    ITRIA = 2 : TRIANGLE 3-4-1
!  IN     : XBAR   : REAL*8 , VECTEUR DE DIMENSION 3
!                    COORDONNEES BARYCENTRIQUES DU POINT DE L'ELEMENT
!                    REEL (BARYCENTRE DES SOMMETS DU TRIANGLE 1-2-3
!                    OU 3-4-1)
!  OUT    : KSI1   : REAL*8 , SCALAIRE
!                    PREMIERE COORDONNEE DU POINT ANTECEDENT DANS LE
!                    REPERE ASSOCIE A L'ELEMENT DE REFERENCE
!  OUT    : KSI2   : REAL*8 , SCALAIRE
!                    SECONDE COORDONNEE DU POINT ANTECEDENT DANS LE
!                    REPERE ASSOCIE A L'ELEMENT DE REFERENCE
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
! ARGUMENTS
! ---------
    integer :: itria
    real(kind=8) :: xbar(*), ksi1, ksi2
!
! VARIABLES LOCALES
! -----------------
    integer :: i, isom(3), j
!
    real(kind=8) :: ksi1el(4), ksi2el(4)
    data          ksi1el / -1.0d0 , -1.0d0 ,  1.0d0 ,  1.0d0 /
    data          ksi2el /  1.0d0 , -1.0d0 , -1.0d0 ,  1.0d0 /
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
! 1   AFFECTATION DES NUMEROS DES SOMMETS
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!
    if (itria .eq. 1) then
        isom(1) = 1
        isom(2) = 2
        isom(3) = 3
    else
        isom(1) = 3
        isom(2) = 4
        isom(3) = 1
    endif
!
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
! 2   CALCUL DES COORDONNEES DE L'ANTECEDENT DANS L'ELEMENT DE REFERENCE
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!
    ksi1 = 0.0d0
    ksi2 = 0.0d0
    do 10 i = 1, 3
        j = isom(i)
        ksi1 = ksi1 + xbar(i) * ksi1el(j)
        ksi2 = ksi2 + xbar(i) * ksi2el(j)
10  end do
!
! --- FIN DE ANTE2D.
end subroutine
