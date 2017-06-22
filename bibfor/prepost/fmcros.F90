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

subroutine fmcros(nbfonc, nbptot, sigm, rd0, rtau0,&
                  rcrit, rphmax, rtaua)
    implicit none
!
#include "jeveux.h"
#include "asterfort/fmampc.h"
#include "asterfort/fmprhm.h"
    integer :: nbfonc, nbptot
    real(kind=8) :: rphmax, rtaua, sigm(nbfonc*nbptot)
    real(kind=8) :: rd0, rtau0, rcrit
!     NBFONC  : IN  : NOMBRE DE FONCTIONS (6 EN 3D 4 EN 2D)
!     NBPTOT  : IN  : NOMBRE DE PAS DE TEMPS DE CALCUL
!     SIGM    : IN  : VECTEUR DES CONTRAINTES EN TOUS LES PAS DE TEMPS
!     RD0     : IN  : VALEUR DE D0
!     RTAU0   : IN  : VALEUR DE TAU0
!     RCRIT   : OUT : VALEUR DU CRITERE
!     RPHMAX  : OUT : VALEUR DE LA PRESSION HYDROSTATIQUE MAXIMALE
!     RTAUA   : OUT : VALEUR DE L4AMPLITUDE DE CISSION
!     -----------------------------------------------------------------
!     ------------------------------------------------------------------
    real(kind=8) :: ra, rb
!
!------- CALCUL DE L'AMPLITUDE DE CISSION
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call fmampc(nbfonc, nbptot, sigm, rtaua)
!
!------- CALCUL DE LA PRESSION HYDROSTATIQUE MAXIMALE -----
!
    call fmprhm(nbfonc, nbptot, sigm, rphmax)
!
!------- CALCUL DU CRITERE
!
    ra = (rtau0-rd0/sqrt(3.d0))/(rd0/3.d0)
    rb = rtau0
    rcrit = rtaua + ra * rphmax - rb
!
end subroutine
