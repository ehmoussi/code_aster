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

subroutine xmafis(noma, cnsln, nxmafi, mafis, nmafis,&
                  lisma)
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/panbno.h"
    integer :: nxmafi, nmafis
    character(len=8) :: noma
    character(len=19) :: cnsln
    character(len=24) :: mafis, lisma
! person_in_charge: samuel.geniaut at edf.fr
!
!                      TROUVER LES MAILLES OÙ LSN CHANGE DE SIGNE
!
!     ENTREE
!       NOMA     :  NOM DE L'OBJET MAILLAGE
!       CNSLN    :  LEVEL-SETS
!       NXMAFI   :  NOMBRE MAX DE MAILLES DE LA ZONE FISSURE
!       LISMA    :  LISTE DES MAILLES DE GROUP_MA_ENRI
!
!     SORTIE
!       MAFIS    :  MAILLES DE LA ZONE FISSURE
!       NMAFIS   :  NOMBRE DE MAILLES DE LA ZONE FISSURE
!     ------------------------------------------------------------------
!
    integer :: jdlima,  jconx2,  jmafis
    integer :: i, imae, in, jma, itypma, nbnott(3)
    integer :: nmaabs, nuno, nbmae, nnos
    real(kind=8) :: lsnp, lsn
    character(len=19) :: mai
    real(kind=8), pointer :: cnsv(:) => null()
    integer, pointer :: connex(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call jelira(lisma, 'LONMAX', nbmae)
    call jeveuo(lisma, 'L', jdlima)
!
    call jeveuo(noma//'.CONNEX', 'L', vi=connex)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', jconx2)
!
    mai=noma//'.TYPMAIL'
    call jeveuo(mai, 'L', jma)
!
!     RÉCUPÉRATION DES LEVEL-SETS
    call jeveuo(cnsln//'.CNSV', 'L', vr=cnsv)
!
    call jeveuo(mafis, 'E', jmafis)
!
    i=0
!     BOUCLE SUR LES MAILLES DE GROUP_ENRI
    do 100 imae = 1, nbmae
        nmaabs=zi(jdlima-1+(imae-1)+1)
        in=1
        nuno=connex(zi(jconx2+nmaabs-1)+in-1)
        lsnp=cnsv((nuno-1)+1)
!
        itypma=zi(jma-1+nmaabs)
        call panbno(itypma, nbnott)
        nnos=nbnott(1)
!
        do 101 in = 2, nnos
            nuno=connex(zi(jconx2+nmaabs-1)+in-1)
            lsn=cnsv((nuno-1)+1)
            if ((lsnp*lsn) .le. 0.d0) then
!           LSN A CHANGÉ DE SIGNE DONC ON STOCKE LA MAILLE DANS MAFIS
                i=i+1
                zi(jmafis-1+i)=nmaabs
!           AUGMENTEZ NXMAFI
                ASSERT((i-1).lt.nxmafi)
                goto 100
            endif
101      continue
100  end do
    nmafis=i
!
    call jedema()
end subroutine
