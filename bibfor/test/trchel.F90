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

subroutine trchel(ific, nocc)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvem.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexnom.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utcmp1.h"
#include "asterfort/utmess.h"
#include "asterfort/tresu_champ_all.h"
#include "asterfort/tresu_champ_cmp.h"
#include "asterfort/tresu_champ_val.h"
#include "asterfort/tresu_ordgrd.h"
#include "asterfort/tresu_read_refe.h"
#include "asterfort/tresu_tole.h"
#include "asterfort/utnono.h"
#include "asterfort/wkvect.h"
    integer, intent(in) :: ific
    integer, intent(in) :: nocc
!     COMMANDE:  TEST_RESU
!                MOT CLE FACTEUR "CHAM_ELEM"
! ----------------------------------------------------------------------
!
    character(len=6) :: nompro
    parameter (nompro='TRCHEL')
!
    integer :: iocc, iret, nbcmp, jcmp, n1, n2, n3, n4, ivari, nupo, nusp
    integer :: irefr, irefi, irefc, nref, nl1, nl2, nl11, nl22, n1r, n2r, n3r
    integer :: irefrr, irefir, irefcr, n1a, n1b, imigma, nbmag
    real(kind=8) :: epsi, epsir
    character(len=1) :: typres
    character(len=3) :: ssigne
    character(len=4) :: chpt
    character(len=8) :: crit, noddl, nomma, typtes, nomail, nomgd
    character(len=11) :: motcle
    character(len=19) :: cham19
    character(len=16) :: tbtxt(2), tbref(2), nom_vari
    character(len=33) :: nonoeu
    character(len=24) :: travr, travi, travc, travrr, travir, travcr, nogrno, nogrma
    character(len=200) :: lign1, lign2
    integer :: iarg
    aster_logical :: lref
    aster_logical :: skip
    real(kind=8) :: ordgrd
!     ------------------------------------------------------------------
    call jemarq()
!
    motcle = 'CHAM_ELEM'
    travr = '&&'//nompro//'_TRAVR          '
    travi = '&&'//nompro//'_TRAVI          '
    travc = '&&'//nompro//'_TRAVC          '
    travrr = '&&'//nompro//'_TRAVR_R        '
    travir = '&&'//nompro//'_TRAVI_R        '
    travcr = '&&'//nompro//'_TRAVC_R        '
    irefi=1
    irefr=1
    irefc=1
    irefir=1
    irefcr=1
    irefrr=1
!
    do iocc = 1, nocc
        lign1 = ' '
        lign2 = ' '
        nonoeu = ' '
        noddl = ' '
        call getvid('CHAM_ELEM', 'CHAM_GD', iocc=iocc, scal=cham19, nbret=n1)
        lign1(1:21)='---- '//motcle(1:9)
        lign1(22:22)='.'
        lign2(1:21)='     '//cham19(1:8)
        lign2(22:22)='.'
        call tresu_read_refe('CHAM_ELEM', iocc, tbtxt)
!
        call getvtx('CHAM_ELEM', 'NOM_CMP', iocc=iocc, scal=noddl, nbret=n1)
        if (n1 .ne. 0) then
            nl1 = lxlgut(lign1)
            nl2 = lxlgut(lign2)
            lign1(1:nl1+16)=lign1(1:nl1-1)//' NOM_CMP'
            lign2(1:nl2+16)=lign2(1:nl2-1)//' '//noddl
            lign1(nl1+17:nl1+17)='.'
            lign2(nl2+17:nl2+17)='.'
        endif
!
        call getvtx('CHAM_ELEM', 'VALE_ABS', iocc=iocc, scal=ssigne, nbret=n1)
        if (ssigne .eq. 'OUI') then
            nl1 = lxlgut(lign1)
            nl2 = lxlgut(lign2)
            lign1(1:nl1+16)=lign1(1:nl1-1)//' VALE_ABS'
            lign2(1:nl2+16)=lign2(1:nl2-1)//' '//ssigne
            lign1(nl1+17:nl1+17)='.'
            lign2(nl2+17:nl2+17)='.'
        endif
!
        call tresu_tole(epsi, mcf='CHAM_ELEM', iocc=iocc)
        call getvtx('CHAM_ELEM', 'CRITERE', iocc=iocc, scal=crit, nbret=n1)
!
        call getvr8('CHAM_ELEM', 'VALE_CALC', iocc=iocc, nbval=0, nbret=n1)
        call getvis('CHAM_ELEM', 'VALE_CALC_I', iocc=iocc, nbval=0, nbret=n2)
        call getvc8('CHAM_ELEM', 'VALE_CALC_C', iocc=iocc, nbval=0, nbret=n3)
!
        skip = .false.
        ordgrd = 1.d0
        if (n1 .ne. 0) then
            nref=-n1
            typres = 'R'
            call jedetr(travr)
            call wkvect(travr, 'V V R', nref, irefr)
            call getvr8('CHAM_ELEM', 'VALE_CALC', iocc=iocc, nbval=nref, vect=zr(irefr),&
                        nbret=iret)
            call tresu_ordgrd(zr(irefr), skip, ordgrd, mcf='CHAM_ELEM', iocc=iocc)
        else if (n2 .ne. 0) then
            nref=-n2
            typres = 'I'
            call jedetr(travi)
            call wkvect(travi, 'V V I', nref, irefi)
            call getvis('CHAM_ELEM', 'VALE_CALC_I', iocc=iocc, nbval=nref, vect=zi(irefi),&
                        nbret=iret)
        else if (n3 .ne. 0) then
            nref=-n3
            typres = 'C'
            call jedetr(travc)
            call wkvect(travc, 'V V C', nref, irefc)
            call getvc8('CHAM_ELEM', 'VALE_CALC_C', iocc=iocc, nbval=nref, vect=zc(irefc),&
                        nbret=iret)
        endif
!
! ----------------------------------------------------------------------
        lref=.false.
        call getvr8('CHAM_ELEM', 'PRECISION', iocc=iocc, scal=epsir, nbret=iret)
        if (iret .ne. 0) then
            lref=.true.
            call getvr8('CHAM_ELEM', 'VALE_REFE', iocc=iocc, nbval=0, nbret=n1r)
            call getvis('CHAM_ELEM', 'VALE_REFE_I', iocc=iocc, nbval=0, nbret=n2r)
            call getvc8('CHAM_ELEM', 'VALE_REFE_C', iocc=iocc, nbval=0, nbret=n3r)
            if (n1r .ne. 0) then
                ASSERT((n1r.eq.n1))
                nref=-n1r
                call jedetr(travrr)
                call wkvect(travrr, 'V V R', nref, irefrr)
                call getvr8('CHAM_ELEM', 'VALE_REFE', iocc=iocc, nbval=nref, vect=zr(irefrr),&
                            nbret=iret)
            else if (n2r.ne.0) then
                ASSERT((n2r.eq.n2))
                nref=-n2r
                call jedetr(travir)
                call wkvect(travir, 'V V I', nref, irefir)
                call getvis('CHAM_ELEM', 'VALE_REFE_I', iocc=iocc, nbval=nref, vect=zi(irefir),&
                            nbret=iret)
            else if (n3r.ne.0) then
                ASSERT((n3r.eq.n3))
                nref=-n3r
                call jedetr(travcr)
                call wkvect(travcr, 'V V C', nref, irefcr)
                call getvc8('CHAM_ELEM', 'VALE_REFE_C', iocc=iocc, nbval=nref, vect=zc(irefcr),&
                            nbret=iret)
            endif
        endif
        if (skip .and. .not. lref) then
            call utmess('A', 'TEST0_11')
        endif
! ----------------------------------------------------------------------
        call getvtx('CHAM_ELEM', 'TYPE_TEST', iocc=iocc, scal=typtes, nbret=n1)
!
        if (n1 .ne. 0) then
!
            nl1 = lxlgut(lign1)
            nl2 = lxlgut(lign2)
            lign1(1:nl1+16)=lign1(1:nl1-1)//' TYPE_TEST'
            lign2(1:nl2+16)=lign2(1:nl2-1)//' '//typtes
            lign1(nl1+17:nl1+17)='.'
            lign2(nl2+17:nl2+17)='.'
!
            call getvtx('CHAM_ELEM', 'NOM_CMP', iocc=iocc, nbval=0, nbret=n4)
            if (n4 .eq. 0) then
                nl1 = lxlgut(lign1)
                nl11 = lxlgut(lign1(1:nl1-1))
                nl2 = lxlgut(lign2)
                nl22 = lxlgut(lign2(1:nl2-1))
                if (nl11 .lt. 80) then
                    write (ific,*) lign1(1:nl11)
                else if (nl11.lt.160) then
                    write (ific,116) lign1(1:80),lign1(81:nl11)
                else
                    write (ific,120) lign1(1:80),lign1(81:160),&
                    lign1(161:nl11)
                endif
                if (nl22 .lt. 80) then
                    write (ific,*) lign2(1:nl22)
                else if (nl22.lt.160) then
                    write (ific,116) lign2(1:80),lign2(81:nl22)
                else
                    write (ific,120) lign2(1:80),lign2(81:160),&
                    lign2(161:nl22)
                endif
                if (lref) then
                    tbref(1)=tbtxt(1)
                    tbref(2)=tbtxt(2)
                    tbtxt(1)='NON_REGRESSION'
                endif
                call tresu_champ_all(cham19, typtes, typres, nref, tbtxt,&
                                     zi(irefi), zr(irefr), zc(irefc), epsi, crit,&
                                     .true._1, ssigne, ignore=skip, compare=ordgrd)
                if (lref) then
                    call tresu_champ_all(cham19, typtes, typres, nref, tbref,&
                                         zi(irefir), zr(irefrr), zc(irefcr), epsir, crit,&
                                         .false._1, ssigne)
                endif
            else
                nbcmp = -n4
                call wkvect('&&OP0023.NOM_CMP', 'V V K8', nbcmp, jcmp)
                call getvtx('CHAM_ELEM', 'NOM_CMP', iocc=iocc, nbval=nbcmp, vect=zk8(jcmp),&
                            nbret=n4)
                if (lref) then
                    tbref(1)=tbtxt(1)
                    tbref(2)=tbtxt(2)
                    tbtxt(1)='NON_REGRESSION'
                endif
                call tresu_champ_cmp(cham19, typtes, typres, nref, tbtxt,&
                                     zi(irefi), zr(irefr), zc(irefc), epsi, lign1,&
                                     lign2, crit, ific, nbcmp, zk8(jcmp),&
                                     .true._1, ssigne, ignore=skip, compare=ordgrd)
                if (lref) then
                    call tresu_champ_cmp(cham19, typtes, typres, nref, tbref,&
                                         zi(irefir), zr(irefrr), zc(irefcr), epsir, lign1,&
                                         lign2, crit, ific, nbcmp, zk8(jcmp),&
                                         .false._1, ssigne)
                endif
                call jedetr('&&OP0023.NOM_CMP')
            endif
!
! ----------------------------------------------------------------------
        else
!
            call getvtx('CHAM_ELEM', 'NOM_CMP', iocc=iocc, scal=noddl, nbret=n1)
            call dismoi('NOM_MAILLA', cham19, 'CHAMP', repk=nomma)
            n1=0
            call getvem(nomma, 'MAILLE', 'CHAM_ELEM', 'MAILLE', iocc,&
                        iarg, 1, nomail, n1a)
            if (n1a .eq. 0) then
                call getvem(nomma, 'GROUP_MA', 'CHAM_ELEM', 'GROUP_MA', iocc, iarg, 1, nogrma, n1b)
                ASSERT(n1b.eq.1)
                call jelira(jexnom(nomma//'.GROUPEMA', nogrma), 'LONUTI', nbmag)
                if ( nbmag .gt. 1) call utmess('F', 'TEST0_20' , sk=nogrma, si=nbmag)
                call jeveuo(jexnom(nomma//'.GROUPEMA', nogrma), 'L', imigma)
                call jenuno(jexnum(nomma//'.NOMMAI', zi(imigma)), nomail)
            endif
!
            if (n1a.ne.0) then
                nl1 = lxlgut(lign1)
                nl2 = lxlgut(lign2)
                lign1(1:nl1+16)=lign1(1:nl1-1)//' MAILLE'
                lign2(1:nl2+16)=lign2(1:nl2-1)//' '//nomail
                lign1(nl1+17:nl1+17)='.'
                lign2(nl2+17:nl2+17)='.'
            else
                nl1 = lxlgut(lign1)
                nl2 = lxlgut(lign2)
                lign1(1:nl1+16)=lign1(1:nl1-1)//' GROUP_MA'
                lign2(1:nl2+16)=lign2(1:nl2-1)//' '//nogrma
                lign1(nl1+17:nl1+17)='.'
                lign2(nl2+17:nl2+17)='.'
            endif
!
            call getvem(nomma, 'NOEUD', 'CHAM_ELEM', 'NOEUD', iocc,&
                        iarg, 1, nonoeu(1:8), n3)
            if (n3 .ne. 0) then
                nl1 = lxlgut(lign1)
                nl2 = lxlgut(lign2)
                lign1(1:nl1+16)=lign1(1:nl1-1)//' NOEUD'
                lign2(1:nl2+16)=lign2(1:nl2-1)//' '//nonoeu(1:8)
                lign1(nl1+17:nl1+17)='.'
                lign2(nl2+17:nl2+17)='.'
            endif
!
            call getvem(nomma, 'GROUP_NO', 'CHAM_ELEM', 'GROUP_NO', iocc,&
                        iarg, 1, nogrno, n4)
            if (n4 .ne. 0) then
                nl1 = lxlgut(lign1)
                nl2 = lxlgut(lign2)
                lign1(1:nl1+16)=lign1(1:nl1-1)//' GROUP_NO'
                lign2(1:nl2+16)=lign2(1:nl2-1)//' '//nogrno
                lign1(nl1+17:nl1+17)='.'
                lign2(nl2+17:nl2+17)='.'
            endif
!
            if (n3 .eq. 1) then
!             RIEN A FAIRE.
            else if (n4.eq.1) then
                call utnono('F', nomma, 'NOEUD', nogrno, nonoeu(1:8),&
                            iret)
                nonoeu(10:33) = nogrno
            endif
!
            call dismoi('NOM_GD', cham19, 'CHAMP', repk=nomgd)
            call utcmp1(nomgd, 'CHAM_ELEM', iocc, noddl, ivari, nom_vari)
            call getvis('CHAM_ELEM', 'SOUS_POINT', iocc=iocc, scal=nusp, nbret=n2)
            if (n2 .eq. 0) nusp = 0
            call getvis('CHAM_ELEM', 'POINT', iocc=iocc, scal=nupo, nbret=n2)
            if (n2 .eq. 0) nupo = 0
!
            if (n2 .ne. 0) then
                nl1 = lxlgut(lign1)
                nl2 = lxlgut(lign2)
                lign1(1:nl1+16)=lign1(1:nl1-1)//' POINT'
                call codent(nupo, 'G', chpt)
                lign2(1:nl2+16)=lign2(1:nl2-1)//' '//chpt
                lign1(nl1+17:nl1+17)='.'
                lign2(nl2+17:nl2+17)='.'
            endif
!
            if (nusp .ne. 0) then
                nl1 = lxlgut(lign1)
                nl2 = lxlgut(lign2)
                lign1(1:nl1+16)=lign1(1:nl1-1)//' SOUS_POINT'
                call codent(nusp, 'G', chpt)
                lign2(1:nl2+16)=lign2(1:nl2-1)//' '//chpt
                lign1(nl1+17:nl1+17)='.'
                lign2(nl2+17:nl2+17)='.'
            endif
!
            nl1 = lxlgut(lign1)
            nl1 = lxlgut(lign1(1:nl1-1))
            nl2 = lxlgut(lign2)
            nl2 = lxlgut(lign2(1:nl2-1))
            write (ific,'(A)') lign1(1:nl1)
            write (ific,*) lign2(1:nl2)
!
            if (lref) then
                tbref(1)=tbtxt(1)
                tbref(2)=tbtxt(2)
                tbtxt(1)='NON_REGRESSION'
            endif
            call tresu_champ_val(cham19, nomail, nonoeu, nupo, nusp,&
                                 ivari, noddl, nref, tbtxt, zi(irefi),&
                                 zr(irefr), zc(irefc), typres, epsi, crit,&
                                 .true._1, ssigne, ignore=skip, compare=ordgrd)
            if (lref) then
                call tresu_champ_val(cham19, nomail, nonoeu, nupo, nusp,&
                                     ivari, noddl, nref, tbref, zi(irefir),&
                                     zr(irefrr), zc(irefcr), typres, epsir, crit,&
                                     .false._1, ssigne)
            endif
            write (ific,*)' '
        endif
! ----------------------------------------------------------------------
    end do
!
    116 format(1x,a80,a)
    120 format(1x,2(a80),a)
!
    call jedetr(travr)
    call jedetr(travc)
    call jedetr(travi)
!
    call jedema()
end subroutine
