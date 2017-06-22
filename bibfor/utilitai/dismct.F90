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

subroutine dismct(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(CATALOGUE)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=32) :: repk
    character(len=*) :: nomobz, repkz
! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM BIDON (1 CARACTERE)
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
!
!
!
!-----------------------------------------------------------------------
    integer :: ianbno, ityma, nbtyma
!-----------------------------------------------------------------------
    call jemarq()
    ASSERT(nomobz.eq.'&')
    repk = ' '
    repi = 0
    ierd = 0
!
    call jelira('&CATA.TM.NBNO', 'NUTIOC', nbtyma)
!
    if (questi .eq. 'NB_TYPE_MA') then
        repi=nbtyma
!
    else if (questi.eq.'NB_NO_MAX') then
        repi=0
        do 1, ityma=1,nbtyma
        call jeveuo(jexnum('&CATA.TM.NBNO', ityma), 'L', ianbno)
        repi=max(repi,zi(ianbno))
 1      continue
!
    else
        ierd=1
    endif
!
    repkz = repk
    call jedema()
end subroutine
