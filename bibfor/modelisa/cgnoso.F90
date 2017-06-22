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

subroutine cgnoso(mofaz, iocc, nomaz, lisnoz, nbno)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/oreino.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
#include "asterfort/utreno.h"
!
    integer :: iocc, nbno
    character(len=*) :: mofaz, nomaz, lisnoz
!
!       CGNOSO -- TRAITEMENT DE L'OPTION "SEGM_DROI_ORDO"
!                 DU MOT FACTEUR CREA_GROUP_NO DE
!                 LA COMMANDE DEFI_GROUP
!
! ----------------------------------------------------------------------
!  MOFAZ         - IN    - K16  - : MOT FACTEUR 'CREA_GROUP_NO'
!  IOCC          - IN    - I    - : NUMERO D'OCCURENCE DU MOT-FACTEUR
!  NOMAZ         - IN    - K8   - : NOM DU MAILLAGE
!  LISNOZ        - JXVAR - K24  - : NOM DE LA LISTE DE NOEUDS
!                                   APPARTENANT A L'ENVELOPPE
!                                   DU CYLINDRE.
!  NBNO          - OUT   -  I   - : LONGUEUR DE CETTE LISTE
! ----------------------------------------------------------------------
!
    integer :: iret,  jnoeu, numori, numext, n1, iera
    real(kind=8) :: tole
    character(len=8) :: noma, crit, nom1
    character(len=16) :: motfac, motcle(2), typmcl(2)
    character(len=24) :: lisnoe, nomnoe
    real(kind=8), pointer :: vale(:) => null()
!     ------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS :
!     ---------------
    motfac = mofaz
    noma = nomaz
    lisnoe = lisnoz
    iera = 0
!
    nomnoe = noma//'.NOMNOE'
!
! --- RECUPERATION DES COORDONNES DES NOEUDS DU MAILLAGE :
!     --------------------------------------------------
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
!
! --- RECUPERATION DES NOEUDS A ORDONNER :
!     ----------------------------------
    motcle(1) = 'GROUP_NO'
    motcle(2) = 'NOEUD'
    typmcl(1) = 'GROUP_NO'
    typmcl(2) = 'NOEUD'
    call reliem(' ', noma, 'NU_NOEUD', motfac, iocc,&
                2, motcle, typmcl, lisnoe, nbno)
    if (nbno .le. 0) then
        call utmess('F', 'MODELISA3_99')
    endif
    call jeveuo(lisnoe, 'E', jnoeu)
!
! --- RECUPERATION DES NOEUDS EXTREMITES :
!     ----------------------------------
    call utreno(motfac, 'ORIG', iocc, noma, nom1)
    call jenonu(jexnom(nomnoe, nom1), numori)
!
    call utreno(motfac, 'EXTR', iocc, noma, nom1)
    call jenonu(jexnom(nomnoe, nom1), numext)
!
! --- RECUPERATION DE LA PRECISION ET DU CRITERE :
!     ------------------------------------------
    call getvr8(motfac, 'PRECISION', iocc=iocc, scal=tole, nbret=n1)
    call getvtx(motfac, 'CRITERE', iocc=iocc, scal=crit, nbret=n1)
!
! --- ON ORDONNE :
!     ----------
    call oreino(noma, zi(jnoeu), nbno, numori, numext,&
                vale, crit, tole, iera, iret)
    ASSERT(iret.eq.0)
!
    call jedema()
!
end subroutine
