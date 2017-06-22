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

subroutine dhrc_calc_b(ab, gb, vint, b, bp1, bp2, bs1, bs2)
!
! person_in_charge: sebastien.fayolle at edf.fr
!
    implicit none
!
#include "asterfort/matini.h"
    real(kind=8), intent(in) :: vint(*)
    real(kind=8), intent(in) :: ab(6, 2, 2), gb(6, 2, 2)
!
!
    real(kind=8), intent(out) :: b(6, 2, 2), bp1(6, 2), bp2(6, 2), bs1(6, 2), bs2(6, 2)
! ----------------------------------------------------------------------
!
!      CALCUL DU TENSEUR DE RAIDEUR B ET DE SES DERIVVES PAR RAPPORT A D
!      APPELE PAR "LCGLCC"
!
! IN:
!       VINT   : VECTEUR DES VARIABLES INTERNES
!                VINT=(D1,D2,EPSP1X,EPSP1Y,EPSP2X,EPSP2Y)
!       AB     : PARAMETRE ALPHA DE LA FONCTION D'ENDOMMAGEMENT
!       GB     : PARAMETRE GAMMA DE LA FONCTION D'ENDOMMAGEMENT
!
! OUT:
!       B     : TENSEUR DE RAIDEUR COUPLE ELAS-PLAS
!       LA PREMIERE COMPOSANTE DE B CORRESPOND AUX DEFORMATIONS M-F
!       LA DEUXIEME COMPOSANTE DE B CORRESPOND AUX GLISSEMENTS
!       LA TROISIEME COMPOSANTE DE B CORRESPOND A LA DISTINCTION
!       ENTRE PARTIE SUPERIEURE ET INFERIEURE DE LA PLAQUE
!       BP1   : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR COUPLE PAR
!               RAPPORT A D1
!       BP2   : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR COUPLE PAR
!               RAPPORT A D2
!       BS1   : DERIVEE SECONDE DU TENSEUR DE RAIDEUR COUPLE PAR
!               RAPPORT A D1
!       BS2   : DERIVEE SECONDE DU TENSEUR DE RAIDEUR COUPLE PAR
!               RAPPORT A D2
!
! -------------------------------------------------------------------
!
    integer :: i, k
!
!
    call matini(6, 2, 0.0d0, bp1)
    call matini(6, 2, 0.0d0, bp2)
    call matini(6, 2, 0.0d0, bs1)
    call matini(6, 2, 0.0d0, bs2)
!
! Termes Bm
!
    do i = 1, 3
        do k = 1, 2
!
            b(i,k,1)=gb(i,k,1)*vint(1)/(ab(i,k,1)+vint(1))
            b(i,k,2)=gb(i,k,2)*vint(2)/(ab(i,k,2)+vint(2))
!
            bp1(i,k)=ab(i,k,1)*gb(i,k,1)/(ab(i,k,1)+vint(1))**2
            bp2(i,k)=ab(i,k,2)*gb(i,k,2)/(ab(i,k,2)+vint(2))**2
!
            bs1(i,k)=-2.d0*ab(i,k,1)*gb(i,k,1)/(ab(i,k,1)+vint(1))**3
            bs2(i,k)=-2.d0*ab(i,k,2)*gb(i,k,2)/(ab(i,k,2)+vint(2))**3
!
        end do
    end do
!
! Termes Bf de signe oppose suite a convetion Aster sur la flexion
!
    do i = 4, 6
        do k = 1, 2
!
            b(i,k,1)=gb(i,k,1)*vint(1)/(ab(i,k,1)+vint(1))
            b(i,k,2)=gb(i,k,2)*vint(2)/(ab(i,k,2)+vint(2))
!
            bp1(i,k)=ab(i,k,1)*gb(i,k,1)/(ab(i,k,1)+vint(1))**2
            bp2(i,k)=ab(i,k,2)*gb(i,k,2)/(ab(i,k,2)+vint(2))**2
!
            bs1(i,k)=-2.d0*ab(i,k,1)*gb(i,k,1)/(ab(i,k,1)+vint(1))**3
            bs2(i,k)=-2.d0*ab(i,k,2)*gb(i,k,2)/(ab(i,k,2)+vint(2))**3
!
        end do
    end do
!
end subroutine
