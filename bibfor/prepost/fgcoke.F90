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

subroutine fgcoke(nbcycl, sigmin, sigmax, n, m,&
                  sm, rke)
    implicit none
#include "jeveux.h"
    real(kind=8) :: sigmin(*), sigmax(*)
    real(kind=8) :: n, m, sm, rke(*)
    integer :: nbcycl
!     AMPLIFICATION DU CHARGEMENT (KE COEFFICIENT DE CORRECTION
!     ELASTO-PLASTIQUE
!     ------------------------------------------------------------------
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  SIGMIN : R   : CONTRAINTES MINIMALES DES CYCLES
! IN  SIGMAX : R   : CONTRAINTES MAXIMALES DES CYCLES
! IN  N      : R   :
! IN  M      : R   :
! IN  SM     : R   :
! OUT RKE    : R   : VALEURS DU COEFFICIENT KE POUR CHAQUE CYCLE
!     ------------------------------------------------------------------
!
    real(kind=8) :: delta
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    do 10 i = 1, nbcycl
        delta = abs(sigmax(i)-sigmin(i))
        if (delta .le. 3.d0*sm) then
            rke(i) = 1.d0
        else if (delta.gt.3.d0*sm.and.delta.lt.3.d0*m*sm) then
            rke(i) = 1.d0 + ((1-n)/(n*(m-1)))*((delta/(3.d0*sm))-1.d0)
        else if (delta.ge.3*m*sm) then
            rke(i) = 1.d0/n
        endif
10  end do
!
end subroutine
