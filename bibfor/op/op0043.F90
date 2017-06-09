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

subroutine op0043()
! person_in_charge: nicolas.greffet at edf.fr
    implicit none
! =====================================================================
!   - FONCTIONS REALISEES:
!       COMMANDE IMPR_MAIL_YACS
!       RECUPERATION DU MAILLAGE FLUIDE LORS D'UN COUPLAGE ASTER-SATURNE
!       VIA YACS
!
!   - OUT :
!       IERR   : NON UTILISE
!     ------------------------------------------------------------
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/precou.h"
#include "asterfort/ulisop.h"
#include "asterfort/ulopen.h"
    integer :: nfis
    character(len=8) :: typema
    character(len=16) :: k16nom
    integer :: n
!
    call jemarq()
    call infmaj()
!
    call getvis(' ', 'UNITE_MAILLAGE', scal=nfis, nbret=n)
! LECTURE DU MAILLAGE FLUIDE
    k16nom='                '
    if (ulisop ( nfis, k16nom ) .eq. 0) then
        call ulopen(nfis, ' ', 'FICHIER-MODELE', 'NEW', 'O')
    endif
    call getvtx(' ', 'TYPE_MAILLAGE', scal=typema, nbret=n)
    call precou(nfis, typema)
!
    write(nfis,*) 'FIN'
    rewind nfis
!
    call jedema()
end subroutine
