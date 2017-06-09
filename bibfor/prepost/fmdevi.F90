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

subroutine fmdevi(nbfonc, nbptot, sigm, dev)
    implicit none
!
#include "jeveux.h"
    integer :: nbfonc, nbptot
    real(kind=8) :: sigm(nbfonc*nbptot)
    real(kind=8) :: dev(nbfonc*nbptot)
!     NBFONC  : IN  : NOMBRE DE FONCTIONS (6 EN 3D 4 EN 2D)
!     NBPTOT  : IN  : NOMBRE DE PAS DE TEMPS DE CALCUL
!     SIGM    : IN  : VECTEUR DES CONTRAINTES EN TOUS LES PAS DE TEMPS
!     DEV     : OUT : VECTEUR DU DEVIATEUR DES CONTRAINTES
!     -----------------------------------------------------------------
!     ------------------------------------------------------------------
    real(kind=8) :: ph
    integer :: i, idec, j
!-----------------------------------------------------------------------
!
!------- CALCUL DU DEVIATEUR -------
!
    do 10 i = 1, nbptot
        idec = (i-1)*nbfonc
        ph = (sigm(idec+1)+sigm(idec+2)+sigm(idec+3))/3.d0
        do 20 j = 1, nbfonc
            dev(idec+j) = sigm(idec+j)
            if (j .le. 3) then
                dev(idec+j)=dev(idec+j)-ph
            endif
20      continue
10  end do
!
end subroutine
