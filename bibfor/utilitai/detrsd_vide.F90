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

subroutine detrsd_vide(typesd, nomsd)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/detrsd.h"
    character(len=*), intent(in) :: typesd, nomsd
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!  but : detruire une structure de donnee si elle est vide
!
!  in   typesd : type de la structure de donnee a detruire
!          'carte'
!       nomsd   : nom de la structure de donnees a detruire
!
!  Resultat:
!     on detruit tous les objets jeveux correspondant a cette SD.
! ----------------------------------------------------------------------
    integer ::  ngedit, iexi
    character(len=19) :: carte
    character(len=24) :: typ2sd
    integer, pointer :: desc(:) => null()
!
! -DEB------------------------------------------------------------------
!
    call jemarq()
    typ2sd = typesd


    if (typ2sd .eq. 'CARTE') then
!   -----------------------------
        carte=nomsd
        call jeexin(carte//'.DESC', iexi)
        if (iexi.eq.0) goto 999
        call jeveuo(carte//'.DESC', 'L', vi=desc)
        ngedit=desc(3)
        if (ngedit.eq.0) then
            call detrsd('CHAMP',carte)
        endif


    else
        call utmess('F', 'UTILITAI_47', sk=typ2sd)
    endif

999 continue
    call jedema()
end subroutine
