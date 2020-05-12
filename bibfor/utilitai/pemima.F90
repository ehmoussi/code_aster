! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine pemima(indch, chamgd, resu, modele, nbocc)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvem.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/pemaxe.h"
#include "asterfort/pemaxn.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsorac.h"
#include "asterfort/rsutnu.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/umalma.h"
#include "asterfort/utmess.h"
#include "asterfort/uttrii.h"
#include "asterfort/wkvect.h"
!
    integer :: nbocc, indch
    character(len=8) :: modele
    character(len=19) :: resu
    character(len=24) :: chamgd
!     OPERATEUR   POST_ELEM
!     TRAITEMENT DU MOT CLE-FACTEUR "MINMAX"
!     ------------------------------------------------------------------
!
    integer :: iret, nbcmp, nzero, nbordr, iocc, nbma, nbtot
    integer :: n1, nr, np, nc, ni, no, jno, jin, numo, tord(1)
    integer :: nbgma, igm, nbpar, nn, inum, nli, nlo, iarg
    parameter(nzero=0,nbpar=3)
    real(kind=8) :: prec, inst
    complex(kind=8) :: cbid
    character(len=8) :: k8b, kbid, mailla, resuco, crit, tych
    character(len=8) :: nomgd
    character(len=8), parameter :: typpar(nbpar) = ['K16','I  ','R  ']
    character(len=8), parameter :: tout='TOUT', grpma='GROUP_MA'
    character(len=24), parameter :: union='UNION_GROUP_MA'
    character(len=16), parameter :: nompar(nbpar) = ['CHAMP_GD  ','NUME_ORDRE','INST      ']
    character(len=19) :: knum, cham, kins, lisins
    character(len=24) :: nomcha, nomlieu
    aster_logical :: exiord
    character(len=8), pointer :: cmp(:) => null()
    character(len=24), pointer :: v_gma(:) => null()
    integer, pointer :: v_lma(:) => null()
    integer, pointer :: v_allma(:) => null()
!     ------------------------------------------------------------------
!
    call jemarq()
!
!     --- CREATION DE LA TABLE
    call tbcrsd(resu, 'G')
    call tbajpa(resu, nbpar, nompar, typpar)
!
!     --- RECUPERATION DU MAILLAGE ET DU NOMBRE DE MAILLES
    call dismoi('NOM_MAILLA', modele, 'MODELE', repk=mailla)
    call dismoi('NB_MA_MAILLA', mailla, 'MAILLAGE', repi=nbma)
!
    if (indch .eq. 0) then
!
!        --- RECUPERATION DU RESULTAT ET DU NUMERO D'ORDRE
        call getvid('MINMAX', 'RESULTAT', iocc=1, scal=resuco, nbret=nr)
        call getvr8('MINMAX', 'PRECISION', iocc=1, scal=prec, nbret=np)
        call getvtx('MINMAX', 'CRITERE', iocc=1, scal=crit, nbret=nc)
        call getvr8('MINMAX', 'INST', iocc=1, nbval=0, nbret=ni)
        call getvis('MINMAX', 'NUME_ORDRE', iocc=1, nbval=0, nbret=no)
        call getvid('MINMAX', 'LIST_INST', iocc=1, nbval=0, nbret=nli)
        call getvid('MINMAX', 'LIST_ORDRE', iocc=1, nbval=0, nbret=nlo)
!
        knum = '&&PEMIMA.NUME_ORDRE'
        kins = '&&PEMIMA.INST'
        exiord=.false.
        if (no .ne. 0) then
            exiord=.true.
            nbordr=-no
            call wkvect(knum, 'V V I', nbordr, jno)
            call getvis('MINMAX', 'NUME_ORDRE', iocc=1, nbval=nbordr, vect=zi(jno),&
                        nbret=iret)
        endif
!
        if (ni .ne. 0) then
            nbordr=-ni
            call wkvect(kins, 'V V R', nbordr, jin)
            call getvr8('MINMAX', 'INST', iocc=1, nbval=nbordr, vect=zr(jin),&
                        nbret=iret)
        endif
!
        if (nli .ne. 0) then
            call getvid('MINMAX', 'LIST_INST', iocc=1, scal=lisins, nbret=iret)
            call jeveuo(lisins // '.VALE', 'L', jin)
            call jelira(lisins // '.VALE', 'LONMAX', nbordr)
        endif
!
        if (nlo .ne. 0) then
            exiord=.true.
            call getvid('MINMAX', 'LIST_ORDRE', iocc=1, scal=lisins, nbret=iret)
            call jeveuo(lisins // '.VALE', 'L', jno)
            call jelira(lisins // '.VALE', 'LONMAX', nbordr)
        endif
!
        nn=nlo+nli+no+ni
        if (nn .eq. 0) then
            exiord=.true.
            call rsutnu(resuco, ' ', 0, knum, nbordr,&
                        prec, crit, iret)
            call jeveuo(knum, 'L', jno)
        endif
!
    else
!        CAS DU CHAMGD
        nbordr=1
        exiord=.true.
    endif
!
!
!     --- ON PARCOURT LES OCCURENCES DU MOT CLE 'MINMAX':
!     =====================================================
!
    do iocc = 1, nbocc
!
!
!     --- BOUCLE SUR LES NUMEROS D'ORDRE:
!     ===================================
!
        do inum = 1, nbordr
!
!
            if (indch .eq. 0) then
!             --- NUME_ORDRE, INST ---
                if (exiord) then
                    numo=zi(jno+inum-1)
                    call rsadpa(resuco, 'L', 1, 'INST', numo,&
                                0, sjv=jin, styp=kbid)
                    inst=zr(jin)
                else
                    inst=zr(jin+inum-1)
                    call rsorac(resuco, 'INST', 0, zr(jin+inum-1), kbid,&
                                cbid, prec, crit, tord, nbordr, iret)
                    numo=tord(1)
                endif
!
!             --- CHAMP DU POST-TRAITEMENT
                call getvtx('MINMAX', 'NOM_CHAM', iocc=iocc, scal=nomcha, nbret=iret)
                call rsexch(' ', resuco, nomcha, numo, cham, iret)
            else
                cham=chamgd(1:19)
                nomcha=chamgd
                numo=0
                inst=0.d0
            endif
!
            call dismoi('TYPE_CHAMP', cham, 'CHAMP', repk=tych, arret='C', ier=iret)
!
            call dismoi('NOM_GD', cham, 'CHAMP', repk=nomgd, arret='C', ier=iret)
            if (nomgd(6:6) .eq. 'C') goto 10
!
!         --- COMPOSANTES DU POST-TRAITEMENT
            call getvtx('MINMAX', 'NOM_CMP', iocc=iocc, nbval=nzero, vect=k8b, nbret=nbcmp)
            nbcmp=-nbcmp
            AS_ALLOCATE(vk8=cmp, size=nbcmp)
            call getvtx('MINMAX', 'NOM_CMP', iocc=iocc, nbval=nbcmp, vect=cmp, nbret=iret)
!
!         --- CALCUL ET STOCKAGE DES MINMAX : MOT-CLE 'TOUT'
!
            call getvtx('MINMAX', 'TOUT', iocc=iocc, nbval=nzero, vect=k8b, nbret=iret)
            if (iret .ne. 0) then
                nomlieu = 'TOUT'
                if (tych(1:2) .eq. 'EL') then
                    call pemaxe(resu, nomcha, tout, nomlieu, modele,&
                                cham, nbcmp, cmp, numo, inst, 0, v_lma)
                else
                    call pemaxn(resu, nomcha, tout, nomlieu, modele,&
                                cham, nbcmp, cmp, numo, inst, 0, v_lma)
                endif
            endif
!
!         --- CALCUL ET STOCKAGE DES MOYENNES : MOT-CLE 'GROUP_MA'
            call getvem(mailla, 'GROUP_MA', 'MINMAX', 'GROUP_MA', iocc,&
                    iarg, 0, k8b, n1)
            nbgma=-n1
            if (nbgma > 0) then
                call wkvect('&&PEMIMA_GMA', 'V V K24', nbgma, vk24=v_gma)
                call getvem(mailla, 'GROUP_MA', 'MINMAX', 'GROUP_MA', iocc,&
                        iarg, nbgma, v_gma, n1)
                do igm = 1, nbgma
                    call jeexin(jexnom(mailla//'.GROUPEMA', v_gma(igm)), iret)
                    if (iret .eq. 0) then
                        call utmess('A', 'UTILITAI3_46', sk=v_gma(igm))
                        goto 30
                    endif
                    call jelira(jexnom(mailla//'.GROUPEMA', v_gma(igm)), 'LONUTI', nbma)
                    if (nbma .eq. 0) then
                        call utmess('A', 'UTILITAI3_47', sk=v_gma(igm))
                        goto 30
                    endif
                    call jeveuo(jexnom(mailla//'.GROUPEMA', v_gma(igm)), 'L', vi=v_lma)
                    if (tych(1:2) .eq. 'EL') then
                        call pemaxe(resu, nomcha, grpma, v_gma(igm), modele,&
                                    cham, nbcmp, cmp, numo, inst, nbma, v_lma)
                    else
                        call pemaxn(resu, nomcha, grpma, v_gma(igm), modele,&
                                    cham, nbcmp, cmp, numo, inst, nbma, v_lma)
                    endif
30 continue
                end do
!
! --- UNION
                if(nbgma > 1) then
                    call umalma(mailla, v_gma, nbgma, v_allma, nbtot)
                    ASSERT(nbtot>0)
                    if (tych(1:2) .eq. 'EL') then
                        call pemaxe(resu, nomcha, grpma, union, modele,&
                                    cham, nbcmp, cmp, numo, inst, nbtot, v_allma)
                    else
                        call pemaxn(resu, nomcha, grpma, union, modele,&
                                    cham, nbcmp, cmp, numo, inst, nbtot, v_allma)
                    endif
                    AS_DEALLOCATE(vi=v_allma)
                end if
!
                call jedetr('&&PEMIMA_GMA')
            endif
!
            AS_DEALLOCATE(vk8=cmp)
!
        end do
!
 10     continue
    end do
!
    call jedema()
!
end subroutine
