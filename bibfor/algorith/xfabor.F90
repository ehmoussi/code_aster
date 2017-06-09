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

subroutine xfabor(noma, cnxinv, nunoa, nunob, nunoc,&
                  fabord)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: nunoa, nunob, nunoc
    character(len=8) :: noma
    character(len=19) :: cnxinv
    aster_logical :: fabord
!
! person_in_charge: samuel.geniaut at edf.fr
!     ------------------------------------------------------------------
!
!      ON VERIFIE SI LES TROIS POINTS APPARTIENNENT A UNE FACE DE BORD
!       DANS LE CADRE DE XFEM (UNIQUEMENT APPELEE EN 3D)
!
!  ENTREES :
!     NOMA     :   NOM DU CONCEPT MAILLAGE
!     CNXINV   :   CONNECTIVITE INVERSE
!     NUNOA    :   ADRESSE DU NOEUD A
!     NUNOB    :   ADRESSE DU NOEUD B
!     NUNOC    :   ADRESSE DU NOEUD C
!
!  SORTIES :
!     FABORD   :   TRUE SSI LA FACE A LAQUELLE APPARTIENNENT LES 3
!                   POINTS EST UNE FACE DE BORD
!
!     ------------------------------------------------------------------
!
    integer :: jma, nmanoa, nmanob, nmanoc, jmanoa, jmanob, jmanoc
    integer :: imaa, imab, imac, itypma, numaa, numab, numac, nbmaco
    integer :: ndime
    character(len=19) :: mai
    character(len=8) :: typma
    integer, pointer :: tmdim(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
!
    mai=noma//'.TYPMAIL'
    call jeveuo(mai, 'L', jma)
    call jeveuo('&CATA.TM.TMDIM', 'L', vi=tmdim)
!
!     RECUPERATION DES MAILLES CONTENANT LE NOEUD A
    call jelira(jexnum(cnxinv, nunoa), 'LONMAX', nmanoa)
    call jeveuo(jexnum(cnxinv, nunoa), 'L', jmanoa)
!
!     RECUPERATION DES MAILLES CONTENANT LE NOEUD B
    call jelira(jexnum(cnxinv, nunob), 'LONMAX', nmanob)
    call jeveuo(jexnum(cnxinv, nunob), 'L', jmanob)
!
!     RECUPERATION DES MAILLES CONTENANT LE NOEUD C
    call jelira(jexnum(cnxinv, nunoc), 'LONMAX', nmanoc)
    call jeveuo(jexnum(cnxinv, nunoc), 'L', jmanoc)
!
!     ON COMPTE LE NBRE DE MAILLES VOLUMIQUES COMMUNES AUX 3 NOEUDS :
    nbmaco=0
!
!     BOUCLE SUR LES MAILLES CONTENANT LE NOEUD A
    do 100 imaa = 1, nmanoa
        numaa = zi(jmanoa-1+imaa)
!
        itypma = zi(jma-1+numaa)
        call jenuno(jexnum('&CATA.TM.NOMTM', itypma), typma)
!
!       NDIME : DIMENSION TOPOLOGIQUE DE LA MAILLE
        ndime= tmdim(itypma)
!
!       SI MAILLE NON VOLUMIQUE ON CONTINUE À 100
        if (ndime .ne. 3) goto 100
!
!       BOUCLE SUR LES MAILLES CONTENANT LE NOEUD B
        do 110 imab = 1, nmanob
            numab = zi(jmanob-1+imab)
!
            itypma = zi(jma-1+numab)
            call jenuno(jexnum('&CATA.TM.NOMTM', itypma), typma)
!
            ndime= tmdim(itypma)
!
!         SI MAILLE NON VOLUMIQUE ON CONTINUE À 110
            if (ndime .ne. 3) goto 110
!
!         SI LA MAILLE EST EN COMMUN AUX NOEUDS A ET B,
!         ON BOUCLE SUR LES MAILLES CONTENANT LE NOEUD C
            if (numaa .eq. numab) then
                do 120 imac = 1, nmanoc
                    numac = zi(jmanoc-1+imac)
!
                    itypma = zi(jma-1+numac)
                    call jenuno(jexnum('&CATA.TM.NOMTM', itypma), typma)
!
                    ndime= tmdim(itypma)
!
!             SI MAILLE NON VOLUMIQUE ON CONTINUE À 120
                    if (ndime .ne. 3) goto 120
!
!             SI LA MAILLE EST EN COMMUN AUX NOEUDS B ET C (ET A),
!             ON A DECOUVERT UNE MAILLE QUE LES TROIS NOEUDS
!             ONT EN COMMUN
                    if (numab .eq. numac) nbmaco=nbmaco+1
!
120             continue
            endif
110     continue
100 end do
!
    ASSERT(nbmaco.gt.0)
!
    fabord=.false.
    if (nbmaco .eq. 1) fabord=.true.
!
    call jedema()
end subroutine
