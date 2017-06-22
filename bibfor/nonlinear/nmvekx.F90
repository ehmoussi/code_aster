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

subroutine nmvekx(imate, tp, xhi, kxhi, dkxidx)
!
    implicit none
!
#include "asterfort/rcvala.h"
    integer :: imate
    real(kind=8) :: xhi, kxhi, dkxidx
!
! ----------------------------------------------------------------------
!     INTEGRATION DE LA LOI DE COMPORTEMENT VISCO PLASTIQUE DE
!     CHABOCHE AVEC ENDOMAGEMENT
!     METHODE ITERATIVE D'EULER IMPLICITE
!
!     CALCUL DE LA CARACTERISTIQUE K DU MATERIAU FONCTION DE TEMPE+ ET
!     DE SIGMA
!     DERIVEE DK/DSIGMA
! ----------------------------------------------------------------------
! IN  IMATE  : ADRESSE DU MATERIAU CODE
!     XHI    : CRITERE D'ENDOMMAGEMENT VISCOPLASTIQUE
!
! OUT KXHI   : CARACTERISTIQUE VISQUEUSE EN T+
!     DKXIDX : DERIVEE DK/DXHI
!
! INFO      KXHI = MATE(9,2) = K_D          (ENDOMMAGEMENT)
! ----------------------------------------------------------------------
!
    real(kind=8) :: vpar(2), tp, wrk(1)
    real(kind=8) :: zero
    parameter    (zero = 0.d0)
    integer :: ok(1)
    character(len=8) :: nompar(2), nom
!
    data nom / 'K_D' /
!
! ----------------------------------------------------------------------
!-- 1. INITIALISATION
!--------------------
    wrk(1) = zero
    dkxidx = zero
!
!-- 2. CALCUL DE K_D(XHI,TEMP) A PARTIR DU MATERIAU CODE
!------------------------------------------------------
    nompar(1) = 'TEMP    '
    nompar(2) = 'X       '
!
    vpar(1) = tp
    vpar(2) = xhi
!
    call rcvala(imate, ' ', 'VENDOCHAB', 2, nompar,&
                vpar, 1, nom, wrk, ok,2)
    kxhi = wrk(1)
end subroutine
