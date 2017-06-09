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

subroutine dhrc_calc_c(c0, ac, gc, vint, c, cp1, cp2, cs1, cs2)
!
! person_in_charge: sebastien.fayolle at edf.fr
!
    implicit none
!
#include "asterfort/matini.h"
    real(kind=8), intent(in) :: vint(*)
    real(kind=8), intent(in) :: c0(2, 2, 2)
    real(kind=8), intent(in) :: ac(2, 2, 2), gc(2, 2, 2)
!
    real(kind=8), intent(out) :: c(2, 2, 2), cp1(2, 2), cp2(2, 2), cs1(2, 2), cs2(2, 2)
! ----------------------------------------------------------------------
!
!      CALCUL DU TENSEUR DE RAIDEUR C ET DE SES DERIVVES PAR RAPPORT A D
!      APPELE PAR "DHRC_LC"
!
! IN:
!       VINT   : VECTEUR DES VARIABLES INTERNES
!                VINT=(D1,D2,EPSP1X,EPSP1Y,EPSP2X,EPSP2Y)
!       C0     : RAIDEUR ELASTIQUE (D=0)
!       AC     : PARAMETRE ALPHA DE LA FONCTION D'ENDOMMAGEMENT
!       GC     : PARAMETRE GAMMA DE LA FONCTION D'ENDOMMAGEMENT
!
! OUT:
!       C(k,l,i) : TENSEUR DE RAIDEUR D'ECROUISSAGE
!                  LA PREMIERE COMPOSANTE DE C CORRESPOND AUX GLISSEMENTS
!                  LA DEUXIEME COMPOSANTE DE C CORRESPOND AUX GLISSEMENTS
!                  LA TROISIEME COMPOSANTE DE C CORRESPOND A LA DISTINCTION
!                  ENTRE PARTIE SUPERIEURE ET INFERIEURE DE LA PLAQUE
!       CP1   : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR ECROUISSAGE PAR
!               RAPPORT A D1
!       CP2   : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR ECROUISSAGE PAR
!               RAPPORT A D2
!       CS1   : DERIVEE SECONDE DU TENSEUR DE RAIDEUR ECROUISSAGE PAR
!               RAPPORT A D1
!       CS2   : DERIVEE SECONDE DU TENSEUR DE RAIDEUR ECROUISSAGE PAR
!               RAPPORT A D2
!
! -------------------------------------------------------------------
!
    integer :: k, l
!
    call matini(2, 2, 0.0d0, cp1)
    call matini(2, 2, 0.0d0, cp2)
    call matini(2, 2, 0.0d0, cs1)
    call matini(2, 2, 0.0d0, cs2)
!
    do k = 1, 2
        do l = 1, 2
            c(k,l,1)=0.5d0*c0(k,l,1)*((ac(k,l,1)+gc(k,l,1)*vint(1))/(ac(k,l,1)+vint(1))+1.d0)
            c(k,l,2)=0.5d0*c0(k,l,2)*((ac(k,l,2)+gc(k,l,2)*vint(2))/(ac(k,l,2)+vint(2))+1.d0)
!
            cp1(k,l)=0.5d0*c0(k,l,1)*ac(k,l,1)*(gc(k,l,1)-1.0d0)/(ac(k,l,1)+vint(1))**2
            cp2(k,l)=0.5d0*c0(k,l,2)*ac(k,l,2)*(gc(k,l,2)-1.0d0)/(ac(k,l,2)+vint(2))**2
!
            cs1(k,l)=-c0(k,l,1)*ac(k,l,1)*(gc(k,l,1)-1.0d0)/(ac(k,l,1)+vint(1))**3
            cs2(k,l)=-c0(k,l,2)*ac(k,l,2)*(gc(k,l,2)-1.0d0)/(ac(k,l,2)+vint(2))**3
        end do
    end do
!
end subroutine
