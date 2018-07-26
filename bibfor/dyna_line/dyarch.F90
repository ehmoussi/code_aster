! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
subroutine dyarch(nbpas, lisins, lisarc, nbarch, ich,&
                  nbexcl, type)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/dyarc1.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
!
integer :: nbpas, nbarch, ich, nbexcl
character(len=*) :: lisins, lisarc, type(*)
!
! --------------------------------------------------------------------------------------------------
!
!     SAISIE DU MOT CLE FACTEUR "ARCHIVAGE"
!
! --------------------------------------------------------------------------------------------------
!
! IN  : NBPAS  : NOMBRE DE PAS DE CALCUL
! IN  : LISINS : NOM DE LA LISTE DES INSTANTS DE CALCUL
! IN  : LISARC : LISTE D'ARCHIVAGE DES PAS DE CALCUL
! OUT : NBARCH : NOMBRE DE PAS A ARCHIVER + CI
! IN  : ICH    : PRISE EN COMPTE DU MOT CLE "CHAM_EXCLU"
! OUT : NBEXCL : NOMBRE DE NOMS DES CHAMPS EXCLUS
! OUT : TYPE   : NOMS DES CHAMPS EXCLUS
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jarch, nbocc, n1, jnum, lnum, k, ipach, jinsc
    real(kind=8) :: epsi
    character(len=8) ::  rela
    character(len=19) :: numarc
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    nbexcl = 0
    call wkvect(lisarc, 'V V I', nbpas, jarch)
!
    call getfac('ARCHIVAGE', nbocc)
!
    if (nbocc .ne. 0) then
        call getvid('ARCHIVAGE', 'LIST_INST', iocc=1, scal=numarc, nbret=n1)
        if (n1 .ne. 0) then
            call jeveuo(lisins, 'L', jinsc)
            call getvr8('ARCHIVAGE', 'PRECISION', iocc=1, scal=epsi, nbret=n1)
            call getvtx('ARCHIVAGE', 'CRITERE', iocc=1, scal=rela, nbret=n1)
            call jeveuo(numarc//'.VALE', 'L', jnum)
            call jelira(numarc//'.VALE', 'LONUTI', lnum)
            call dyarc1(zr(jinsc), nbpas, zr(jnum), lnum, zi(jarch),&
                        epsi, rela)
            zi(jarch+nbpas-1) = 1
            goto 100
        endif
!
        call getvr8('ARCHIVAGE', 'INST', iocc=1, nbval=0, nbret=n1)
        if (n1 .ne. 0) then
            call jeveuo(lisins, 'L', jinsc)
            lnum = -n1
            call getvr8('ARCHIVAGE', 'PRECISION', iocc=1, scal=epsi, nbret=n1)
            call getvtx('ARCHIVAGE', 'CRITERE', iocc=1, scal=rela, nbret=n1)
            call wkvect('&&DYARCH.VALE_INST', 'V V R', lnum, jnum)
            call getvr8('ARCHIVAGE', 'INST', iocc=1, nbval=lnum, vect=zr(jnum),&
                        nbret=n1)
            call dyarc1(zr(jinsc), nbpas, zr(jnum), lnum, zi(jarch),&
                        epsi, rela)
            call jedetr('&&DYARCH.VALE_INST')
            zi(jarch+nbpas-1) = 1
            goto 100
        endif
!
        call getvis('ARCHIVAGE', 'PAS_ARCH', iocc=1, scal=ipach, nbret=n1)
        if (n1 .eq. 0) ipach = 1
!
        do k = ipach, nbpas, ipach
            zi(jarch+k-1) = 1
        end do
        zi(jarch+nbpas-1) = 1
!
100     continue
!
        if (ich .ne. 0) then
            call getvtx('ARCHIVAGE', 'CHAM_EXCLU', iocc=1, nbval=0, nbret=n1)
            if (n1 .ne. 0) then
                nbexcl = -n1
                call getvtx('ARCHIVAGE', 'CHAM_EXCLU', iocc=1, nbval=nbexcl, vect=type,&
                            nbret=n1)
            endif
        endif
    else
        do k = 1, nbpas
            zi(jarch+k-1) = 1
        end do
    endif
!
!     --- 1 : CONDITIONS INITIALES ---
    nbarch = 1
    do k = 1, nbpas
        nbarch = nbarch + zi(jarch+k-1)
    end do
!
    call jedema()
end subroutine
