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

subroutine dchapg(sig1, sig2, npg, nbsig, decha)
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/norsig.h"
    integer :: npg, nbsig
    real(kind=8) :: sig1(*), sig2(*), decha(*)
!
!     BUT:
!       CALCUL DE L'INDICATEUR LOCAL DE DECHARGE DECHA
!       I = (NORME(SIG2) - NORME(SIG1))/NORME(SIG2)
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   SIG1     : CONTRAINTES INSTANT +
! IN   SIG2     : CONTRAINTES INSTANT -
! IN   NPG      : NOMBRE DE POINT DE GAUSS
!
!      SORTIE :
!-------------
! OUT  DECHA    : INDICATEUR DE DECHARGE AU POINTS DE GAUSS
!
! ......................................................................
!
    integer :: igau
!
    real(kind=8) :: zero, un, norm1, norm2, zernor
!
! ----------------------------------------------------------------------
!
    zero = 0.0d0
    un = 1.0d0
    zernor = 10.0d0*r8prem()
!
    do 10 igau = 1, npg
!      CALCUL DU SECOND INVARIANT DU TENSEUR DES CONTRAINTES :
!
        norm1 = norsig(sig1(1+ (igau-1)*nbsig),nbsig)
        norm2 = norsig(sig2(1+ (igau-1)*nbsig),nbsig)
!
!     DANS LE CAS OU NORME(SIG2) = 0 :
!     SI NORME(SIG1) = 0, ON MET L'INDICATEUR A 0
!     SINON IL Y A EU DECHARGE ET ON MET L'INDICATEUR A -1 :
!
        if (norm2 .le. zernor) then
            if (norm1 .le. zernor) then
                decha(igau) = zero
            else
                decha(igau) = -un
            endif
        else
            decha(igau) = (norm2-norm1)/norm2
        endif
10  end do
!
end subroutine
