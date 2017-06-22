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

subroutine utflmd(mailla, limail, nbmail, dim, typmai,&
                  nbtrou, litrou)
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/utflm2.h"
#include "asterfort/wkvect.h"
    character(len=8), intent(in) :: mailla
    character(len=*), intent(in) :: limail
    integer, intent(in) :: nbmail
    integer, intent(in) :: dim
    character(len=*), intent(in) :: typmai
    integer, intent(out) :: nbtrou
    character(len=*), intent(out) :: litrou
! person_in_charge: josselin.delmas at edf.fr
!
!     BUT:
!       FILTRER UNE LISTE DE MAILLE D'APRES LEUR DIMENSION
!       *           *        *                   *
!       IDEM QUE UTFLM2 MAIS AVEC UN VECTEUR JEVEUX
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   MAILLA    : NOM DU MAILLAGE
! IN   LIMAIL    : LISTE DES MAILLES (OBJET JEVEUX)
! IN   NBMA      : NOMBRE DE MAILLES DE LA LISTE
! IN   NDIM      : DIMENSION DES MAILLES A TROUVER (-1,0,1,2,3)
! IN   TYPMAI    : SI DIM=-1, ON FILTRE SUR TYPMAI='QUAD4'/'TRIA3'/...
!                  SINON, ON NE SE SERT PAS DE TYPMAI
!
!      SORTIE :
!-------------
! OUT  NBTROU    : NOMBRE DE MAILLE TROUVEES
! OUT  LITROU    : LISTE DES MAILLES TROUVEES (OBJET JEVEUX)
!                  SI NBTROU = 0, L'OBJET JEVEUX N'EST PAS CREE
!
!.......................................................................
!
!
!
!
!
    integer :: ilimai, lonmax, itrma
!
!
! ----------------------------------------------------------------------
    call jemarq()
!
    call jeveuo(limail, 'L', ilimai)
    call jelira(limail, 'LONMAX', lonmax)
    ASSERT(nbmail.le.lonmax)
    call wkvect(litrou, 'V V I', nbmail, itrma)
!
    call utflm2(mailla, zi(ilimai), nbmail, dim, typmai,&
                nbtrou, zi(itrma))
!
    if (nbtrou .gt. 0) then
        call juveca(litrou, nbtrou)
    else
        call jedetr(litrou)
    endif
    call jedema()
end subroutine
