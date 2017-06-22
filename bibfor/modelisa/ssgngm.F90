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

subroutine ssgngm(noma, iocc, nbgnaj)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvem.h"
#include "asterfort/getvtx.h"
#include "asterfort/gmgnre.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: noma
!     BUT: AJOUTER S'IL LE FAUT A UN MAILLAGE DES GROUP_NO DE MEME NOM
!          QUE LES GROUP_MA ET CONTENANT LES NOEUDS DE CES MAILLES.
!
!     IN: NOMA  : NOM DU MAILLAGE.
!         IOCC  : NUMERO D'OCCURENCE DU MOT CLEF CREA_GROUP_NO
!-----------------------------------------------------------------------
!
    character(len=8) :: k8b, koui
    character(len=16) :: selec
    character(len=24) :: grpma, grpno, nomgno, nomgma
    integer :: iarg
!
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, iad2, ialgma, ialima, ialino, ianbno, iangno
    integer :: ibid, ier, iocc, iret, j, jtrav
    integer :: n1, nb, nbgma, nbgnaj, nbgno, nbma, nbnoto
    integer :: no
!-----------------------------------------------------------------------
    call jemarq()
    grpma = noma//'.GROUPEMA       '
    grpno = noma//'.GROUPENO       '
    nbgnaj = 0
    selec = 'TOUS'
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbnoto)
    if (nbnoto .eq. 0) goto 60
!
!     ---  CAS : "TOUT_GROUP_MA"
!     --------------------------
    call getvtx('CREA_GROUP_NO', 'TOUT_GROUP_MA', iocc=iocc, scal=koui, nbret=n1)
    if (n1 .eq. 1) then
        call jelira(noma//'.GROUPEMA', 'NMAXOC', nbgma)
        call wkvect('&&SSGNGM.LISTE_GMA', 'V V K24', nbgma, ialgma)
        do i = 1, nbgma
            call jenuno(jexnum(grpma, i), zk24(ialgma-1+i))
        end do
        iangno = ialgma
!
!     ---  CAS : "GROUP_MA"
!     ---------------------
    else
!
!      CRITERE DE SELECTION
        call getvtx('CREA_GROUP_NO', 'CRIT_NOEUD', iocc=iocc, scal=selec, nbret=ibid)
        call getvem(noma, 'GROUP_MA', 'CREA_GROUP_NO', 'GROUP_MA', iocc,&
                    iarg, 0, k8b, nb)
        call getvtx('CREA_GROUP_NO', 'NOM', iocc=iocc, nbval=0, nbret=no)
        nbgma = -nb
        call wkvect('&&SSGNGM.LISTE_GMA', 'V V K24', nbgma, ialgma)
        call getvem(noma, 'GROUP_MA', 'CREA_GROUP_NO', 'GROUP_MA', iocc,&
                    iarg, nbgma, zk24(ialgma), nb)
        if (no .ne. 0) then
            nbgno = -no
            if (nbgno .ne. nbgma) then
                call utmess('F', 'MODELISA7_8')
            endif
            call wkvect('&&SSGNGM.NOM_GNO', 'V V K24', nbgno, iangno)
            call getvtx('CREA_GROUP_NO', 'NOM', iocc=iocc, nbval=nbgno, vect=zk24(iangno),&
                        nbret=no)
        else
            iangno = ialgma
        endif
        ier = 0
        do i = 1, nbgma
            nomgma = zk24(ialgma-1+i)
            call jeexin(jexnom(grpma, nomgma), iret)
            if (iret .eq. 0) then
                ier = ier + 1
                call utmess('E', 'ELEMENTS_62', sk=nomgma)
            endif
        end do
        ASSERT(ier.eq.0)
    endif
    if (nbgma .eq. 0) goto 60
!
    call wkvect('&&SSGNGM.LISTE_NO ', 'V V I', nbnoto, ialino)
    call wkvect('&&SSGNGM.TRAV ', 'V V I', nbnoto, jtrav)
    call wkvect('&&SSGNGM.NB_NO    ', 'V V I', nbgma, ianbno)
!
! ---------------------------------------------------------------------
!     -- ON AJOUTE LES NOUVEAUX GROUPES:
!
    do i = 1, nbgma
        nomgma = zk24(ialgma-1+i)
        call jelira(jexnom(grpma, nomgma), 'LONUTI', nbma)
        call jeveuo(jexnom(grpma, nomgma), 'L', ialima)
        call gmgnre(noma, nbnoto, zi(jtrav), zi(ialima), nbma,&
                    zi(ialino), zi(ianbno-1+i), selec)
!
        nomgno = zk24(iangno-1+i)
        n1 = zi(ianbno-1+i)
        call jeexin(jexnom(grpno, nomgno), iret)
        if (iret .gt. 0) then
            call utmess('A', 'MODELISA7_9', sk=nomgno)
        else
            call jecroc(jexnom(grpno, nomgno))
            call jeecra(jexnom(grpno, nomgno), 'LONMAX', max(n1, 1))
            call jeecra(jexnom(grpno, nomgno), 'LONUTI', n1)
            call jeveuo(jexnom(grpno, nomgno), 'E', iad2)
            do j = 1, n1
                zi(iad2-1+j) = zi(ialino-1+j)
            end do
            nbgnaj = nbgnaj + 1
        endif
    end do
!
 60 continue
    call jedetr('&&SSGNGM.LISTE_GMA')
    call jedetr('&&SSGNGM.NOM_GNO')
    call jedetr('&&SSGNGM.LISTE_NO')
    call jedetr('&&SSGNGM.TRAV')
    call jedetr('&&SSGNGM.NB_NO')
    call jedema()
end subroutine
