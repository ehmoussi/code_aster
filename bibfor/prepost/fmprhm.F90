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

subroutine fmprhm(nbfonc, nbptot, sigm, rphmax)
    implicit none
!
#include "jeveux.h"
    integer :: nbfonc, nbptot
    real(kind=8) :: sigm(nbfonc*nbptot)
    real(kind=8) :: rphmax
!     NBFONC  : IN  : NOMBRE DE FONCTIONS (6 EN 3D 4 EN 2D)
!     NBPTOT  : IN  : NOMBRE DE PAS DE TEMPS DE CALCUL
!     SIGM    : IN  : VECTEUR DES CONTRAINTES EN TOUS LES PAS DE TEMPS
!     RPHMAX  : OUT : VALEUR DU DE LA PRESSION HYDROSTATIQUE MAXIMALE
!
    real(kind=8) :: rph
!
! ------- CALCUL DE LA PRESSION HYDROSTATIQUE MAXIMALE---
!
!-----------------------------------------------------------------------
    integer :: i, ide
!-----------------------------------------------------------------------
    rphmax=(sigm(1)+sigm(2)+sigm(3))/3.d0
    do 10 i = 2, nbptot
        ide = (i-1)*nbfonc
        rph=(sigm(ide+1)+sigm(ide+2)+sigm(ide+3))/3.d0
        if (rph .gt. rphmax) rphmax = rph
10  end do
!
end subroutine
