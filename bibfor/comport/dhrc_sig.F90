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

subroutine dhrc_sig(eps, vint, a, b, sig)
!
! person_in_charge: sebastien.fayolle at edf.fr
!
    implicit none
!
#include "asterfort/r8inir.h"
    real(kind=8), intent(in) :: vint(*), eps(8)
    real(kind=8), intent(in) :: a(6, 6), b(6, 2, 2)
    real(kind=8), intent(out) :: sig(8)
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
!       B       : TENSEUR ASSOCIE AUX DEFORMATIONS PLASTIQUES
!       C       : TENSEUR DE RAIDEUR D'ÉCROUISSAGE PLASTIQUE
!
! OUT:
!       SIG     : CONTRAINTES GENERALISEES ASSOCIEES AUX
!                 DEFORMATIONS MEMBRANAIRE, DE FLEXION ET DE GLISSEMENT
!                 (NXX NYY NXY MXX MYY MXY)
! ----------------------------------------------------------------------
!
    integer :: i, k
!
!     INITIALISATION
    call r8inir(8, 0.0d0, sig, 1)
!
    do k = 1, 6
!     CALCUL DE SIG
        do i = 1, 6
            sig(k) = sig(k)+a(k,i)*eps(i)
            if (i .lt. 3) then
                sig(k) = sig(k)+(b(k,i,1)*vint(i+2) +b(k,i,2)*vint(i+4))
            endif
        end do
    end do
!
end subroutine
