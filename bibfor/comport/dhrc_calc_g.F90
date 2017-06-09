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

subroutine dhrc_calc_g(eps, vint, ap1, bp1, cp1, ap2, bp2, cp2, g1, g2)
!
! person_in_charge: sebastien.fayolle at edf.fr
!
    implicit none
!
    real(kind=8), intent(in) :: ap1(6, 6), bp1(6, 2), cp1(2, 2)
    real(kind=8), intent(in) :: ap2(6, 6), bp2(6, 2), cp2(2, 2)
    real(kind=8), intent(in) :: vint(*), eps(6)
!
    real(kind=8), intent(out) :: g1, g2
!
! ----------------------------------------------------------------------
!
!      CALCUL DES FORCES THERMODYNAMIQUES ASSOCIEES A L'ENDOMMAGEMENT
!      APPELE PAR "SEUGLC"
!
! IN:
!       EPS   : TENSEUR DE DEFORMATIONS
!               (EXX EYY 2EXY KXX KYY 2KXY)
!       A       : TENSEUR ELASTIQUE ENDOMMAGE
!       B       : TENSEUR ASSOCIE AUX DEFORMATIONS PLASTIQUES
!       C       : TENSEUR DE RAIDEUR D'ÉCROUISSAGE PLASTIQUE
!       LA TROISIEME COMPOSANTE DE B ET C CORRESPOND A LA DISTINCTION
!       ENTRE PARTIE SUPERIEURE ET INFERIEURE DE LA PLAQUE
!       AP1     : DERIVEE DU TENSEUR A PAR RAPPORT A D1
!       BP1     : DERIVEE DU TENSEUR B PAR RAPPORT A D1
!       CP1     : DERIVEE DU TENSEUR C PAR RAPPORT A D1
!       AP2     : DERIVEE DU TENSEUR A PAR RAPPORT A D2
!       BP2     : DERIVEE DU TENSEUR B PAR RAPPORT A D2
!       CP2     : DERIVEE DU TENSEUR C PAR RAPPORT A D2
!       VINT   : VECTEUR DES VARIABLES INTERNES
!                VINT=(D1,D2,EPSP1X,EPSP1Y,EPSP2X,EPSP2Y)
!
! OUT:
!       G1      : TAUX DE RESTITUTION D'ENERGIE POUR D1
!       G2      : TAUX DE RESTITUTION D'ENERGIE POUR D2
!
! ----------------------------------------------------------------------
!
    integer :: i, k
!
    g1=0.0d0
    g2=0.0d0
!
    do k = 1, 6
        do i = 1, 6
            g1 = g1 + eps(k) * ap1(k,i) * eps(i)
            g2 = g2 + eps(k) * ap2(k,i) * eps(i)
            if (i .lt. 3) then
                g1 = g1 + 2.d0 * eps(k) * bp1(k,i) * vint(i+2)
                g2 = g2 + 2.d0 * eps(k) * bp2(k,i) * vint(i+4)
                if (k .lt. 3) then
                    g1 = g1 + vint(k+2) * cp1(k,i) * vint(i+2)
                    g2 = g2 + vint(k+4) * cp2(k,i) * vint(i+4)
                endif
            endif
        end do
    end do
!
    g1 = -g1*0.5d0
    g2 = -g2*0.5d0
!
end subroutine
