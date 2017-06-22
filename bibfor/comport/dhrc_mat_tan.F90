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

subroutine dhrc_mat_tan(a, ap1, ap2, b,&
                  bp1, bp2, bocaj, neta1, neta2,&
                  indip, cstseu, eps, vint, dsidep)
!
! person_in_charge: sebastien.fayolle at edf.fr
!
    implicit none
#include "asterfort/matini.h"
    integer, intent(in) :: indip(6)
    real(kind=8), intent(in) :: eps(8), vint(*)
    real(kind=8), intent(in) :: a(6, 6), ap1(6, 6), ap2(6, 6)
    real(kind=8), intent(in) :: b(6, 2, 2), bp1(6, 2), bp2(6, 2)
    real(kind=8), intent(in) :: neta1(2), neta2(2), cstseu(6)
    real(kind=8), intent(in) :: bocaj(6, 6)
    real(kind=8), intent(out) :: dsidep(6, 6)
!
! ----------------------------------------------------------------------
!
!      CALCUL DES FORCES THERMODYNAMIQUES ASSOCIEES A LA PLASTICITE
!      APPELE PAR "SEUGLC"
!
! IN:
!       EPS     : TENSEUR DE DEFORMATIONS
!                 (EXX EYY 2EXY KXX KYY 2KXY)
!       VINT    : VECTEUR DES VARIABLES INTERNES
!                 VINT=(D1,D2,EPSP1X,EPSP1Y,EPSP2X,EPSP2Y)
!       A       : TENSEUR DE RAIDEUR ELASTIQUE ENDOMMAGEE
!       AP1     : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR ELASTIQUE PAR
!                 RAPPORT A D1
!       AP2     : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR ELASTIQUE PAR
!                 RAPPORT A D2
!       B       : TENSEUR DE RAIDEUR COUPLE ELAS-PLAS
!       BP1     : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR COUPLE PAR
!                 RAPPORT A D1
!       BP2     : DERIVEE PREMIERE DU TENSEUR DE RAIDEUR COUPLE PAR
!                 RAPPORT A D2
!       NETA1   : CONTRAINTE ASSOCIEE AU GLISSEMENT SUR LA PARTIE 1 DE
!                 LA PLAQUE
!       NETA2   : CONTRAINTE ASSOCIEE AU GLISSEMENT SUR LA PARTIE 2 DE
!                 LA PLAQUE
!       CSTSEU  : PARAMETRES DE SEUILS
!            (1): POUR L'ENDOMMAGEMENT
!            (2): POUR LE GLISSEMENT
!       BOCAJ   : INVERSE DE LA MATRICE JACOBIENNE DES SEUILS ACTIVÉS
!
! OUT:
!       DSIDEP  : MATRICE DE RAIDEUR TANGENTE
!
! ----------------------------------------------------------------------
!
    integer :: i, j, jb, k, l, lb
    real(kind=8) :: dsida(6, 6), dsedep(6, 6)
!
    do k = 1, 6
        do i = 1, 6
            dsidep(k,i)=a(k,i)
        end do
    end do
!
! ----------------------------------------------------------------------
!     CALCUL DE DSIDA
!     DIFFERENTIELLES DES CONTRAINTES N ET M PAR RAPPORT AUX VARI D ET EGLISS
! ---------------------------------------------------------------------------
!     INITIALISATION
    dsida(:,:) = 0.d0
!
    do k = 1, 6
        do i = 1, 6
            dsida(k,1) = dsida(k,1)+ap1(k,i)*eps(i)
            dsida(k,2) = dsida(k,2)+ap2(k,i)*eps(i)
            if (i .lt. 3) then
                dsida(k,1) = dsida(k,1)+bp1(k,i)*vint(i+2)
                dsida(k,2) = dsida(k,2)+bp2(k,i)*vint(i+4)
            endif
        end do
        dsida(k,3) = b(k,1,1)
        dsida(k,4) = b(k,2,1)
        dsida(k,5) = b(k,1,2)
        dsida(k,6) = b(k,2,2)
    end do
!
!----------------------------------------------------------------------
!     CALCUL DE DSEDEP
!----------------------------------------------------------------------
!     INITIALISATION
!
    do k = 1, 6
        dsedep(1,k) = dsida(k,1)/cstseu(1)
        dsedep(2,k) = dsida(k,2)/cstseu(2)
        dsedep(3,k) = dsida(k,3)*2.d0*neta1(1)/(cstseu(3)**2.d0)
        dsedep(4,k) = dsida(k,4)*2.d0*neta1(2)/(cstseu(4)**2.d0)
        dsedep(5,k) = dsida(k,5)*2.d0*neta2(1)/(cstseu(5)**2.d0)
        dsedep(6,k) = dsida(k,6)*2.d0*neta2(2)/(cstseu(6)**2.d0)
    end do
!
!----------------------------------------------------------------------
!    CALCUL DE DSIDEP
!    DERIVEES DES VARI PAR RAPPORT AUX DEFORMATIONS GENERALISEES =
!    bocaj(jb,lb)*dsedep(l,i)
!----------------------------------------------------------------------
!
    do k = 1, 6
        do i = 1, 6
            jb=0
            do j = 1, 6
                lb=0
                if (indip(j) .eq. j) then
                    jb=jb+1
                    do l = 1, 6
                        if (indip(l) .eq. l) then
                            lb=lb+1
                            dsidep(k,i)=dsidep(k,i)+ dsida(k,j)*bocaj(jb,lb)*dsedep(l,i)
                        endif
                    end do
                endif
            end do
        end do
    end do
!
end subroutine
