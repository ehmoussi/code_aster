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

subroutine utncmp(cham19, ncmp, nomobj)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dgmode.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisdg.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/nbec.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: ncmp
    character(len=*) :: cham19, nomobj
!
!     RECUPERE LE NOMBRE ET LES NOMS DES COMPOSANTES D'UN CHAMP
!
!     ------------------------------------------------------------------
!
    integer :: jprno, gd, nec, tabec(10), j, ino, iec, icmp, ncmpmx
    integer ::  iad, kcmp, igr, mode, nnoe,  nbgrel, irepe, nbel
    integer :: jmod, imodel, ilong, idescr,  nb
    character(len=4) :: tych
    character(len=24) :: valk(2)
    character(len=8) :: noma
    character(len=19) :: ch19, prno, noligr
    integer, pointer :: vicmp(:) => null()
    integer, pointer :: celd(:) => null()
    integer, pointer :: desc(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    ch19 = cham19
    ncmp = 0
!
    call dismoi('TYPE_CHAMP', ch19, 'CHAMP', repk=tych)
    call dismoi('NOM_MAILLA', ch19, 'CHAMP', repk=noma)
    call dismoi('NUM_GD', ch19, 'CHAMP', repi=gd)
!
    call jeveuo('&CATA.GD.DESCRIGD', 'L', idescr)
    nec = nbec( gd)
    ASSERT(nec.le.10)
    call jelira(jexnum('&CATA.GD.NOMCMP', gd), 'LONMAX', ncmpmx)
    call jeveuo(jexnum('&CATA.GD.NOMCMP', gd), 'L', iad)
    AS_ALLOCATE(vi=vicmp, size=ncmpmx)
!
!     ==================================================================
!                            C H A M _ N O
!     ==================================================================
    if (tych(1:4) .eq. 'NOEU') then
        call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nnoe)
        call dismoi('PROF_CHNO', ch19, 'CHAM_NO', repk=prno)
        if (prno .eq. ' ') then
!AS OU LE CHAMP EST A PROFIL CONSTANT (CHAMP DE GEOMETRIE)
            call jeveuo(ch19//'.DESC', 'L', vi=desc)
            ncmp = - desc(2)
            do iec = 1, nec
                tabec(iec)= desc(1+1+iec)
            end do
            nb = 0
            do icmp = 1, ncmpmx
                if (exisdg(tabec,icmp)) then
                    do j = 1, ncmp
                        if (vicmp(j) .eq. icmp) goto 34
                    end do
                    nb = nb + 1
                    vicmp(nb) = icmp
                endif
 34             continue
            end do
        else
            call jeveuo(jexnum(prno//'.PRNO', 1), 'L', jprno)
            do ino = 1, nnoe
                do iec = 1, nec
                    tabec(iec)= zi(jprno-1+(ino-1)*(nec+2)+2+iec )
                end do
                do icmp = 1, ncmpmx
                    if (exisdg(tabec,icmp)) then
                        do j = 1, ncmp
                            if (vicmp(j) .eq. icmp) goto 14
                        end do
                        ncmp = ncmp + 1
                        vicmp(ncmp) = icmp
                    endif
 14                 continue
                end do
            end do
        endif
!
!     ==================================================================
!                             C H A M _ E L E M
!     ==================================================================
    else if (tych(1:2) .eq. 'EL') then
        call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nbel)
        call dismoi('NOM_LIGREL', ch19, 'CHAMP', repk=noligr)
        call dismoi('NB_GREL', noligr, 'LIGREL', repi=nbgrel)
        call jeveuo(ch19//'.CELD', 'L', vi=celd)
        call jeveuo(noligr//'.REPE', 'L', irepe)
        call jeveuo('&CATA.TE.MODELOC', 'L', imodel)
        call jeveuo(jexatr('&CATA.TE.MODELOC', 'LONCUM'), 'L', ilong)
        do igr = 1, nbgrel
            mode=celd(celd(4+igr) +2)
            if (mode .eq. 0) goto 20
            jmod = imodel+zi(ilong-1+mode)-1
            nec = nbec( zi(jmod-1+2))
            call dgmode(mode, imodel, ilong, nec, tabec)
            do icmp = 1, ncmpmx
                if (exisdg( tabec , icmp )) then
                    do j = 1, ncmp
                        if (vicmp(j) .eq. icmp) goto 22
                    end do
                    ncmp = ncmp + 1
                    vicmp(ncmp) = icmp
                endif
 22             continue
            end do
 20         continue
        end do
!
    else
        valk(1) = tych
        valk(2) = ch19
        call utmess('F', 'ALGORITH9_69', nk=2, valk=valk)
    endif
!
    if (ncmp .eq. 0) then
        call utmess('F', 'UTILITAI5_53')
    endif
!
    call wkvect(nomobj, 'V V K8', ncmp, kcmp)
    do icmp = 1, ncmp
        zk8(kcmp+icmp-1) = zk8(iad-1+vicmp(icmp))
    end do
    AS_DEALLOCATE(vi=vicmp)
!
    call jedema()
end subroutine
