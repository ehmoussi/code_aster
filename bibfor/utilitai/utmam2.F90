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

subroutine utmam2(modele, nbma, nbtrou, tatrou)
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    integer :: nbma, nbtrou, tatrou(nbma)
    character(len=8) :: modele
!
! person_in_charge: josselin.delmas at edf.fr
!
!     BUT:
!       FILTRER LES MAILLES AFFECTEES PAR LE MODELE
!                   **                       **
!       IDEM QUE UTMAMO MAIS AVEC UNE LISTE DE MAILLE
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   MODELE    : NOM DU MODELE
! IN   NBMA      : NOMBRE DE MAILLE DU MAILLAGE
!
!      SORTIE :
!-------------
! OUT  NBTROU    : NOMBRE DE MAILLE TROUVEES
! OUT  LITROU    : LISTE DES MAILLES TROUVEES (OBJET JEVEUX)
!                  SI NBTROU = 0, L'OBJET JEVEUX N'EST PAS CREE
!
!.......................................................................
!
    integer :: nbmail, ima, itrou
    integer, pointer :: liste_m_temp(:) => null()
    integer, pointer :: maille(:) => null()
!
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call jeveuo(modele//'.MAILLE', 'L', vi=maille)
    call jelira(modele//'.MAILLE', 'LONMAX', nbmail)
    ASSERT(nbma.eq.nbmail)
!
    AS_ALLOCATE(vi=liste_m_temp, size=nbmail)
!
    nbtrou = 0
!
    do 10, ima=1,nbmail
    if (maille(ima) .gt. 0) then
        nbtrou=nbtrou+1
        liste_m_temp(nbtrou)=ima
    endif
    10 end do
!
    if (nbtrou .eq. 0) goto 9999
!
    do 20 itrou = 1, nbtrou
        tatrou(itrou) = liste_m_temp(itrou)
20  end do
!
9999  continue
!
    call jedema()
!
    AS_DEALLOCATE(vi=liste_m_temp)
!
end subroutine
