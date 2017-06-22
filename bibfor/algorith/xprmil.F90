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

subroutine xprmil(noma, cnslt, cnsln)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/conare.h"
#include "asterfort/dismoi.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/ismali.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/nomil.h"
!
    character(len=19) :: cnslt, cnsln
    character(len=8) :: noma
!
! person_in_charge: patrick.massin at edf.fr
!     ------------------------------------------------------------------
!
!       XPRMIL   : X-FEM PROPAGATION ; EXTENSION AUX NOEUDS MILIEUX
!       ------     -     --                                 ---
!    EXTENSION DES CHAM_NO_S LEVEL SETS AUX NOEUDS MILIEUX
!     AFIN DE RESTITUER, APRES PROPAGATION, UNE FISSURE DANS LA MEME
!     CONFIGURATION QU'APRES LES 2 PREMIERES PARTIES DE OP0041
!
!    ENTREE
!        NOMA   : NOM DU MAILLAGE
!        CNSLT  : CHAM_NO_S LST
!        CNSLN  : CHAM_NO_S LSN
!
!    SORTIE
!        CNSLT  : CHAM_NO_S LST
!        CNSLN  : CHAM_NO_S LSN
!
!     ------------------------------------------------------------------
!
!
    integer :: ifm, niv, nbma, jma,  jconx2,   ima
    integer :: ar(12, 3), nbar, ia, na, nb, nunoa, nunob, nmil, nunom
    integer :: nm(12), nbar2
    real(kind=8) :: lsna, lsnb, lsta, lstb
    character(len=8) :: typma
    character(len=19) :: mai
    real(kind=8), pointer :: lnno(:) => null()
    real(kind=8), pointer :: ltno(:) => null()
    integer, pointer :: connex(:) => null()
!
!-----------------------------------------------------------------------
!     DEBUT
!-----------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
    call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nbma)
    mai=noma//'.TYPMAIL'
    call jeveuo(mai, 'L', jma)
    call jeveuo(noma//'.CONNEX', 'L', vi=connex)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', jconx2)
!
    call jeveuo(cnsln//'.CNSV', 'E', vr=lnno)
    call jeveuo(cnslt//'.CNSV', 'E', vr=ltno)
!
!     BOUCLE SUR TOUTES LES MAILLES DU MAILLAGE
    do ima = 1, nbma
        call jenuno(jexnum('&CATA.TM.NOMTM', zi(jma-1+ima)), typma)
!
        if (ismali(typma)) goto 100
!
        call conare(typma, ar, nbar)
!
!       ON RECUPERE LES NUMEROS DES NOEUDS MILIEUX
!       DE TOUTES LES ARETES DE L'ELEMENT
        call nomil(typma, nm, nbar2)
!
        ASSERT(nbar.eq.nbar2)
!
!       BOUCLE SUR LES ARETES DE LA MAILLE
        do ia = 1, nbar
!       ON RECUPERE LES NUMEROS DES 2 NOEUDS DE L'ARETE
            na=ar(ia,1)
            nb=ar(ia,2)
            nunoa=connex(zi(jconx2+ima-1)+na-1)
            nunob=connex(zi(jconx2+ima-1)+nb-1)
!
!       ON CALCULE LES LEVEL SETS AUX 2 NOEUDS
            lsna=lnno((nunoa-1)+1)
            lsnb=lnno((nunob-1)+1)
            lsta=ltno((nunoa-1)+1)
            lstb=ltno((nunob-1)+1)
!
!       ON RECUPERE LE NUMERO DU NOEUD MILIEU
            nmil=nm(ia)
            nunom=connex(zi(jconx2+ima-1)+nmil-1)
!
!       ON REMPLI LES CHAM_NO_S AVEC LES VALEUR DE LEVEL SETS MOYENNES
            lnno((nunom-1)+1) = (lsna+lsnb)/2.d0
            ltno((nunom-1)+1) = (lsta+lstb)/2.d0
!
        end do
100     continue
    end do
!
!-----------------------------------------------------------------------
!     FIN
!-----------------------------------------------------------------------
    call jedema()
end subroutine
