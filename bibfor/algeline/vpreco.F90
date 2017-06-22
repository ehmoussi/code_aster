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

subroutine vpreco(nbvect, neq, vecred, vect)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    integer :: nbvect, neq
    real(kind=8) :: vect(neq, nbvect), vecred(nbvect, nbvect)
!     EFFECTUE LE PROLONGEMENT DES VECTEURS PROPRES : CALCUL DES
!     VECTEURS PROPRES DU SYSTEME COMPLET A PARTIR DES VECTEURS
!     PROPRES DU SYSTEME  REDUIT ET D'UNE MATRICE DE PASSAGE
!     (VECTEURS DE LANCZOS )
!     ------------------------------------------------------------------
!     NBVECT : IN  : NOMBRE DE MODES
!     NEQ    : IN  : NOMBRE D'INCONNUES
!     VECRED : IN  : MATRICE MODALE (CARREE) DU SYSTEME REDUIT
!     VECT   : IN  : MATRICE DE PASSAGE (RECTANGULAIRE)
!              OUT : MATRICE MODALE (RECTANGULAIRE) DU SYSTEME COMPLET
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i,  j, k, l
    real(kind=8) :: rt
    real(kind=8), pointer :: vilig(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    AS_ALLOCATE(vr=vilig, size=nbvect)
!
    do 10 i = 1, neq
        do 20 j = 1, nbvect
            vilig(j) = vect(i,j)
20      continue
        do 30 k = 1, nbvect
            rt = 0.d0
            do 40 l = 1, nbvect
                rt = rt + vilig(l) * vecred(l,k)
40          continue
            vect(i,k) = rt
30      continue
10  end do
!
    AS_DEALLOCATE(vr=vilig)
!
    call jedema()
end subroutine
