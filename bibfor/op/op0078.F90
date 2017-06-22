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

subroutine op0078()
    implicit none
!
!
!     OPERATEUR REST_COND_TRAN
!
! ----------------------------------------------------------------------
!
!
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/tran78.h"
#include "asterfort/utmess.h"
    character(len=8) :: nomres, resin
    character(len=16) :: nomcmd, typres, champ(4)
    integer :: i, j
    integer :: ir, nbcham
!
!     -----------------------------------------------------------------
!
!
    call jemarq()
    call infmaj()
!
!     -----------------------------------------------------------------
!
!
    call getres(nomres, typres, nomcmd)
!
! --- PHASE DE TEST SUR LES CHAMPS A RESTITUER
!
    call getvtx(' ', 'NOM_CHAM', nbval=4, vect=champ, nbret=nbcham)
    if (nbcham .lt. 0) then
        call utmess('E', 'ALGORITH9_44')
    else
        do 20 i = 1, nbcham
            do 10 j = i+1, nbcham
                if (champ(i) .eq. champ(j)) then
                    call utmess('E', 'ALGORITH9_30')
                endif
10          continue
20      continue
    endif
!
    call getvid(' ', 'RESULTAT', scal=resin, nbret=ir)
    call tran78(nomres, typres, resin)
!
!
    call jedema()
end subroutine
