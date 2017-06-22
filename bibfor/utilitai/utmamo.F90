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

subroutine utmamo(modele, nbtrou, litrou)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/juveca.h"
#include "asterfort/utmam2.h"
#include "asterfort/wkvect.h"
    integer :: nbtrou
    character(len=8) :: modele
    character(len=*) :: litrou
!
! person_in_charge: josselin.delmas at edf.fr
!
!     BUT:
!       FILTRER LES MAILLES AFFECTEES PAR LE MODELE
!                   **                       **
!       IDEM QUE UTMAM2 MAIS AVEC UN VECTEUR JEVEUX
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   MODELE    : NOM DU MODELE
!
!      SORTIE :
!-------------
! OUT  NBTROU    : NOMBRE DE MAILLE TROUVEES
! OUT  LITROU    : LISTE DES MAILLES TROUVEES (OBJET JEVEUX)
!                  SI NBTROU = 0, L'OBJET JEVEUX N'EST PAS CREE
!
!.......................................................................
!
    integer :: nbmail
    integer :: itrma
!
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call jelira(modele//'.MAILLE', 'LONMAX', nbmail)
!
    call wkvect(litrou, 'V V I', nbmail, itrma)
!
    call utmam2(modele, nbmail, nbtrou, zi(itrma))
!
    if (nbtrou .gt. 0) then
        call juveca(litrou, nbtrou)
    else
        call jedetr(litrou)
    endif
!
    call jedema()
!
end subroutine
