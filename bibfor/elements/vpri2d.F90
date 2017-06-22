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

subroutine vpri2d(sig, sigi)
! ......................................................................
! .  - FONCTION REALISEE:  CALCUL DU MAX DES VALEURS PROPRES D'UN      .
    implicit none
! .         TENSEUR DE TYPE CONTRAINTE/DEFORMATION 2D                  .
! .  - ARGUMENTS:                                                      .
! .      DONNEES:          SIG      -->                                .
! .      RESULTATS:       SIGI     <--                                .
! ......................................................................
!
!
#include "jeveux.h"
    real(kind=8) :: sig(4), sigi
    real(kind=8) :: s, sp, al1, al2, delta, sqd
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    s = sig(1)+sig(2)
    sp= sig(1)-sig(2)
    delta=sp**2+4.d0*sig(4)**2
    sqd = sqrt(delta)
    al1 = (s+sqd)/2.d0
    al2 = (s-sqd)/2.d0
    sigi = max(al1,al2,sig(3),0.d0)
end subroutine
