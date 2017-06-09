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

subroutine utcmp2(nomgd, mcfac, iocc, dim, nomcmp,&
                  numcmp, nbcmp)
    implicit none
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/knincl.h"
#include "asterfort/lxliis.h"
#include "asterfort/utmess.h"
!
    integer :: iocc, dim, nbcmp, numcmp(*)
    character(len=*) :: nomgd, mcfac, nomcmp(*)
! BUT :  SCRUTER LE MOT CLE MFAC/NOM_CMP ET RENDRE LA LISTE DES CMPS
! -----
!  ARGUMENTS :
!  -----------
!  NOMGD  IN  K8 : NOM DE LA GRANDEUR CONCERNEE
!  MCFAC  IN  K* : NOM DU MOT CLE FACTEUR A SCRUTER
!  IOCC   IN  I  : NUMERO DE L'OCCURRENCE DE MCFAC
!  DIM    IN  I  : LONGUEUR DES TABLEAUX NOMCMP ET NUMCMP
!
!  NOMCMP(*) OUT K8 : NOMS DES COMPOSANTES TROUVEES
!  NUMCMP(*) OUT I  : NUMEROS DES COMPOSANTES TROUVEES (SI VARI_R)
!  NBCMP     OUT I  : NOMBRE DE CMPS TROUVEES
!
! ----------------------------------------------------------------------
    integer :: n2, i, nucmp, iret, jnocmp, lgncmp
    character(len=8) :: k8b, nocmp
    character(len=16) :: nomcmd
!     ------------------------------------------------------------------
!
    call jemarq()
    call getres(k8b, k8b, nomcmd)
!
!
    call getvtx(mcfac, 'NOM_CMP', iocc=iocc, nbval=0, nbret=n2)
    nbcmp=-n2
    ASSERT(dim.ge.nbcmp)
!
    call getvtx(mcfac, 'NOM_CMP', iocc=iocc, nbval=nbcmp, vect=nomcmp,&
                nbret=n2)
!
!
    if (nomgd(1:6) .eq. 'VARI_R') then
!     -----------------------------------------
        do 10 i = 1, nbcmp
            nocmp=nomcmp(i)
            ASSERT(nocmp(1:1).eq.'V')
            call lxliis(nocmp(2:8), nucmp, iret)
            ASSERT(iret.eq.0)
            numcmp(i)=nucmp
10      continue
!
!
!     -- CAS NOMGD /= VARI_R
!     -----------------------
    else
        call jeveuo(jexnom('&CATA.GD.NOMCMP', nomgd), 'L', jnocmp)
        call jelira(jexnom('&CATA.GD.NOMCMP', nomgd), 'LONMAX', lgncmp)
        call knincl(8, nomcmp, nbcmp, zk8(jnocmp), lgncmp,&
                    iret)
        if (iret .ne. 0) then
            call utmess('F', 'CALCULEL5_6', sk=nomgd)
        endif
    endif
!
!
!
    call jedema()
end subroutine
