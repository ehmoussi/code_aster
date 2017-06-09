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

subroutine dxefro(ne, t2iu, edgle, edglc)
    implicit none
#include "asterfort/utbtab.h"
#include "asterfort/pmavec.h"
    integer, intent(in) :: ne
    real(kind=8), intent(in) :: t2iu(2, 2)
    real(kind=8), intent(in) :: edgle(*)
    real(kind=8), intent(out) :: edglc(*)
!     ------------------------------------------------------------------
!     PASSAGE DES EFFORTS OU DEFORMATIONS GENERALISES DU REPERE
!     INTRINSEQUE DE L'ELEMENT AU REPERE LOCAL DE LA COQUE
!     ------------------------------------------------------------------
!     IN  NE    I      NOMBRE DE POINTS A TRAITER
!     IN  T2IU  R 2,2  MATRICE DE PASSAGE INTRINSEQUE - UTILISATEUR
!     IN  EDGLE R  8   NXX NYY NXY MXX MYY MXY QX QY
!     OUT EDGLC R  8   NXX NYY NXY MXX MYY MXY QX QY
!  OU IN  EDGLE R  8   EXX EYY EXY KXX KYY KXY GAX GAY
!     OUT EDGLE R  8   EXX EYY EXY KXX KYY KXY GAX GAY
!     
!     ATTENTION : LES DEFORMATIONS GENERALISEES SONT ATTENDUES SOUS LA FORME
!     EXX EYY EXY ET NON PAS SOUS LA FORME EXX EYY 2EXY.
!
!  REMARQUE : ON PEUT APPELER CETTE ROUTINE AVEC LE MEME TABLEAU EN E/S
!     ------------------------------------------------------------------
    real(kind=8) :: nle(2,2), mle(2,2), qle(2)
    real(kind=8) :: nlc(2,2), mlc(2,2), qlc(2)
    real(kind=8) ::t2ui(2,2), xab(2,2)
    integer :: i
!
!   Transposée de t2iu pour changement de repère des efforts tranchants
    t2ui(1,1) = t2iu(1,1)
    t2ui(2,1) = t2iu(1,2)
    t2ui(1,2) = t2iu(2,1)
    t2ui(2,2) = t2iu(2,2)
!
    do i = 1, ne
        nle(1,1) = edgle(1+8*(i-1))
        nle(2,1) = edgle(3+8*(i-1))
        nle(1,2) = edgle(3+8*(i-1))
        nle(2,2) = edgle(2+8*(i-1))
!
        mle(1,1) = edgle(4+8*(i-1))
        mle(2,1) = edgle(6+8*(i-1))
        mle(1,2) = edgle(6+8*(i-1))
        mle(2,2) = edgle(5+8*(i-1))
!
        qle(1)   = edgle(7+8*(i-1))
        qle(2)   = edgle(8+8*(i-1))
!
        call utbtab('ZERO', 2, 2, nle, t2iu, xab, nlc)
        call utbtab('ZERO', 2, 2, mle, t2iu, xab, mlc)
        call pmavec('ZERO', 2, t2ui, qle, qlc)
!
        edglc(1+8*(i-1)) = nlc(1,1)
        edglc(2+8*(i-1)) = nlc(2,2)
        edglc(3+8*(i-1)) = nlc(2,1)
!
        edglc(4+8*(i-1)) = mlc(1,1)
        edglc(5+8*(i-1)) = mlc(2,2)
        edglc(6+8*(i-1)) = mlc(2,1)
!
        edglc(7+8*(i-1)) = qlc(1)
        edglc(8+8*(i-1)) = qlc(2)
    end do
end subroutine
