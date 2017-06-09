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

subroutine pipere(npg, a, tau, nsol, eta)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterc/r8maem.h"
    integer :: npg, nsol
    real(kind=8) :: a(0:1, npg), tau
    real(kind=8) :: eta(2)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
!
! RESOLUTION P(ETA) = TAU POUR LE PILOTAGE PAR PREDICTION ELASTIQUE OU
! DEFORMATION
!
! ----------------------------------------------------------------------
!
!
! IN  NPG    : NOMBRE DE POINTS DE GAUSS CONSIDERES
! IN  A      : COEFFICIENT DE LA DROITE TAU = A(1,G)*ETA + A(0,G)
! IN  TAU    : SECOND MEMBRE DE L'EQUATION SCALAIRE
! OUT NSOL   : NOMBRE DE SOLUTIONS (0, 1 OU 2)
! OUT ETA    : SOLUTIONS OU ESTIMATION SI NSOL=0
!
! ----------------------------------------------------------------------
!
    integer :: g
    real(kind=8) :: x, infini
!
! ----------------------------------------------------------------------
!
!
! -- INITIALISATION DE I0
!
    infini = r8maem()
    eta(1) = -infini
    eta(2) = infini
!
!
! -- CONSTRUCTION DES INTERVALLES IG PAR RECURRENCE
!
    do 10 g = 1, npg
!
!      LA PENTE DE LA DROITE CONSIDEREE EST NULLE
        if (abs(a(1,g)) .le. abs(tau - a(0,g))/infini) then
!
!      SON ORDONNEE EST SUPERIEURE AU SECOND MEMBRE -> PAS DE SOL.
            if (a(0,g) .gt. tau) goto 1000
!
!
!      LA PENTE DE LA DROITE CONSIDEREE EST NEGATIVE
        else if (a(1,g) .lt. 0) then
            x = (tau - a(0,g)) / a(1,g)
            if (x .gt. eta(2)) then
                eta(1) = eta(2)
                goto 1000
            else if (x .gt. eta(1)) then
                eta(1) = x
            endif
!
!
!      LA PENTE DE LA DROITE CONSIDEREE EST POSITIVE
        else
            x = (tau - a(0,g)) / a(1,g)
            if (x .lt. eta(1)) then
                eta(2) = eta(1)
                goto 1000
            else if (x .lt. eta(2)) then
                eta(2) = x
            endif
!
        endif
10  end do
!
!
! -- TRAITEMENT DU NOMBRE DE SOLUTION
!
    if (eta(1) .eq. -infini .and. eta(2) .eq. infini) then
        goto 1000
    else if (eta(1).eq.-infini) then
        nsol = 1
        eta(1) = eta(2)
    else if (eta(2).eq.infini) then
        nsol = 1
        eta(2) = eta(1)
    else
        nsol = 2
    endif
    goto 9999
!
!
! -- CONSTRUCTION D'UNE ESTIMATION QUAND L'INTERVALLE EST VIDE
!
1000  continue
    nsol = 0
    if (eta(1) .eq. -infini) eta(1) = eta(2)
    if (eta(1) .eq. infini) eta(1) = 0.d0
!
!
9999  continue
end subroutine
