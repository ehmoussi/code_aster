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

subroutine jspgno(l, a, b)
    implicit none
    real(kind=8) :: a(21), b(14), l
!-----------------------------------------------------------------------
!    PERMET LE PASSAGE DU CHAMPS DE CONTRAINTES CALCULEES AUX POINTS DE
!    GAUSS AUX NOEUDS
!
!     EN ENTREE :
!                L : LONGUEUR DE L'ELEMENT
!                A : VECTEUR DES EFFORTS GENERALISES AUX POINTS
!                    D'INTEGRATION
!     EN SORTIE :
!                B : VECTEUR DES EFFORTS GENERALISES AUX NOEUDS
!-----------------------------------------------------------------------
    real(kind=8) :: mfypg1, mfypg2, mfzpg1, mfzpg2, mtpg1, mtpg2
    real(kind=8) :: const1, const2, const3, xpg
!
!-----------------------------------------------------------------------
    real(kind=8) :: deux, undemi
!-----------------------------------------------------------------------
    undemi = 0.5d0
    deux = 2.0d0
    xpg = sqrt(0.6d0)
!
! --- AFFECTATION DES EFFORTS NORMAUX ET DES BIMOMENTS AUX
! --- POINTS D'INTEGRATION AUX EFFORTS NODAUX :
!     ---------------------------------------
    b(1) = a(1)
    b(7) = a(7)
    b(8) = a(15)
    b(14)= a(21)
!
! --- NOTATIONS PLUS PARLANTES :
!     ------------------------
    mtpg1 = a(4)
    mfypg1 = a(5)
    mfzpg1 = a(6)
    mtpg2 = a(11)
    mfypg2 = a(12)
    mfzpg2 = a(13)
!
! --- EXTRAPOLATION LINEAIRE DES MOMENTS DE FLEXION AUX NOEUDS
! --- L'ABSCISSE DU PREMIER NOEUD SUR L'ELEMENT DE REFERENCE EST -1
! --- L'ABSCISSE DU SECOND NOEUD SUR L'ELEMENT DE REFERENCE EST +1 :
!     ------------------------------------------------------------
    const1 = -deux*(mtpg1 - mtpg2)/(l*xpg)
    const2 = -deux*(mfypg1 - mfypg2)/(l*xpg)
    const3 = -deux*(mfzpg1 - mfzpg2)/(l*xpg)
!
    b(4) = -const1*undemi*l + mtpg2
    b(5) = -const2*undemi*l + mfypg2
    b(6) = -const3*undemi*l + mfzpg2
!
    b(11) = const1*undemi*l + mtpg2
    b(12) = const2*undemi*l + mfypg2
    b(13) = const3*undemi*l + mfzpg2
!
! --- DETERMINATION DES EFFORTS TRANCHANTS PAR LES EQUATIONS D'EQUILIBRE
! --- RELIANT LES EFFORTS TRANCHANTS AUX MOMENTS DE FLEXION
! ---     VY + D(MFZ)/DX = 0
! ---     VZ - D(MFY)/DX = 0
! --- LES DERIVEES DES MOMENTS DE FLEXION ETANT APPROXIMEES PAR
! --- DIFFERENCES FINIES :
!     ------------------
    b(2) = -deux*(mfzpg2-mfzpg1)/(l*xpg)
    b(3) = deux*(mfypg2-mfypg1)/(l*xpg)
    b(9) = b(2)
    b(10)=  b(3)
!
end subroutine
