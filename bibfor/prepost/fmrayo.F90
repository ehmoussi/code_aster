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

subroutine fmrayo(nbfonc, nbptot, sigm, rayon)
    implicit   none
#include "jeveux.h"
#include "asterfort/fmdevi.h"
#include "asterfort/jedetr.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    integer :: nbfonc, nbptot
    real(kind=8) :: sigm(*), rayon
!     NBFONC  : IN  : NOMBRE DE FONCTIONS (6 EN 3D 4 EN 2D)
!     NBPTOT  : IN  : NOMBRE DE PAS DE TEMPS DE CALCUL
!     SIGM    : IN  : VECTEUR DES CONTRAINTES EN TOUS LES PAS DE TEMPS
!     RAYON   : OUT : VALEUR RAYON SPHERE CIRCONSCRITE AU CHARGEMENT
!     -----------------------------------------------------------------
!     ------------------------------------------------------------------
    integer ::  nbr, i, j, n2
    real(kind=8) :: eps, x, sig(6), rau(6), p, pmac, a
    real(kind=8), pointer :: deviat(:) => null()
!     ------------------------------------------------------------------
!
    eps = 1.d-3
    x = 5.d-2
!
!------- CALCUL DU DEVIATEUR -------
!
    AS_ALLOCATE(vr=deviat, size=nbfonc*nbptot)
    call fmdevi(nbfonc, nbptot, sigm,deviat)
!
!---- CALCUL DE LA SPHERE CIRCONSCRITE AU CHARGEMENT ----
!
!---- INITIALISATION
!
    rayon = 0.d0
    do 10 j = 1, nbfonc
        rau(j) = 0.d0
        do 20 i = 1, nbptot
            rau(j) = rau(j) + deviat(1+(i-1)*nbfonc+j-1)
20      continue
        rau(j) = rau(j) / nbptot
10  end do
    nbr = 0
!
!-----CALCUL RECURRENT
!
    n2 = 1
30  continue
    n2 = n2 + 1
    if (n2 .gt. nbptot) n2 = n2 - nbptot
    do 40 j = 1, nbfonc
        sig(j) = deviat(1+(n2-1)*nbfonc+j-1)-rau(j)
40  end do
    if (nbfonc .eq. 6) then
        pmac = (&
               sig(1)*sig(1)+sig(2)*sig(2)+sig(3)*sig(3) )/2.d0 + sig(4)*sig(4) + sig(5)*sig(5) +&
               & sig(6)*sig(6&
               )
    else if (nbfonc .eq. 4) then
        pmac = (sig(1)*sig(1)+sig(2)*sig(2)+sig(3)*sig(3) )/2.d0 + sig(4)*sig(4 )
    endif
    pmac = sqrt(pmac)
    p = pmac - rayon
    if (p .gt. eps) then
        nbr = 0
        rayon = rayon + x*p
        a = ( pmac - rayon ) / pmac
        do 50 j = 1, nbfonc
            rau(j) = rau(j) + a*sig(j)
50      continue
    else
        nbr = nbr + 1
    endif
    if (nbr .lt. nbptot) goto 30
!
    AS_DEALLOCATE(vr=deviat)
!
end subroutine
