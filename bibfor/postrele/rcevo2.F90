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

subroutine rcevo2(nbinti, kinti, csigm, cinst, csiex,&
                  kemixt, cstex, csmex, lfatig, flexio,&
                  lrocht, cnoc, cresu, cpres)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/r8vide.h"
#include "asterfort/detrsd.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rc32my.h"
#include "asterfort/tbexip.h"
#include "asterfort/tbextb.h"
#include "asterfort/tbexv1.h"
#include "asterfort/tbliva.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: nbinti
    aster_logical :: lfatig, flexio, lrocht, kemixt
    character(len=16) :: kinti
    character(len=24) :: csigm, cinst, csiex, cnoc, cresu, cpres, cstex, csmex
!     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
!     LECTURE DU MOT CLE FACTEUR "TRANSITOIRE"
!
!     ------------------------------------------------------------------
!
    integer :: ibid, n1, nbinst, kinst, ncmpr, i, j, k, l, ndim
    integer :: nbabsc, jabsc, jsigm, jinst, ncmp, iret, nbtran, jsioe, iocc
    integer :: nbins0, jnocc, ii, jresu, nbcycl, jresp, jstoe, lo, le
    integer :: jsmoe
    parameter  ( ncmp = 6 )
    real(kind=8) :: r8b, prec(2), momen0, momen1, vale(2)
    complex(kind=8) :: cbid
    aster_logical :: exist, cfait, flexii
    character(len=8) :: k8b, crit(2), nocmp(ncmp)
    character(len=16) :: motclf, valek(2), table, tabl0, tabfle, tabfl0, tabpre
    character(len=16) :: tabpr0
    character(len=19) :: nomf
    character(len=24) :: instan, abscur
    character(len=24) :: valk(7)
    real(kind=8), pointer :: cont_flexio(:) => null()
    real(kind=8), pointer :: cont_pressi(:) => null()
    real(kind=8), pointer :: contraintes(:) => null()
! DEB ------------------------------------------------------------------
    call jemarq()
!
    r8b=0.d0
    motclf = 'TRANSITOIRE'
    call getfac(motclf, nbtran)
    if (nbtran .eq. 0) goto 9999
!
    nocmp(1) = 'SIXX'
    nocmp(2) = 'SIYY'
    nocmp(3) = 'SIZZ'
    nocmp(4) = 'SIXY'
    nocmp(5) = 'SIXZ'
    nocmp(6) = 'SIYZ'
!
    valek(1) = 'INST            '
    valek(2) = 'ABSC_CURV       '
!
    prec(1) = 1.0d-06
    prec(2) = 1.0d-06
    crit(1) = 'RELATIF'
    crit(2) = 'RELATIF'
!
    instan = '&&RCEVO2.INSTANT'
    abscur = '&&RCEVO2.ABSC_CURV'
!
! --- RECHERCHE DU NOMBRE D'INSTANTS A COMBINER
!
    nbinst = 0
    flexio = .false.
    do 10 iocc = 1, nbtran, 1
        cfait = .false.
!
        call getvid(motclf, 'TABL_RESU_MECA', iocc=iocc, scal=tabl0, nbret=n1)
        call getvid(motclf, 'TABL_SIGM_THER', iocc=iocc, scal=tabfl0, nbret=n1)
        if (n1 .ne. 0) flexio = .true.
        call getvid(motclf, 'TABL_RESU_PRES', iocc=iocc, scal=tabpr0, nbret=n1)
        if (n1 .ne. 0) lrocht = .true.
!
        nbins0 = 0
        call getvr8(motclf, 'INST', iocc=iocc, nbval=0, nbret=n1)
        if (n1 .ne. 0) then
            nbins0 = -n1
        else
            call getvid(motclf, 'LIST_INST', iocc=iocc, scal=nomf, nbret=n1)
            if (n1 .ne. 0) then
                call jelira(nomf//'.VALE', 'LONMAX', nbins0)
            else
                if (nbinti .eq. 1) then
                    table = tabl0
                    tabfle = tabfl0
                    tabpre = tabpr0
                else
                    cfait = .true.
                    table = '&&RCEVO2.RESU_ME'
                    tabfle = '&&RCEVO2.SIGM_TH'
                    tabpre = '&&RCEVO2.RESU_PR'
                    call tbextb(tabl0, 'V', table, 1, 'INTITULE',&
                                'EQ', [ibid], [r8b], [cbid], kinti,&
                                [r8b], k8b, iret)
                    if (iret .eq. 10) then
                        valk(1) = 'INTITULE'
                        valk(2) = tabl0
                        call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                    else if (iret .eq. 20) then
                        valk(1) = tabl0
                        valk(2) = 'INTITULE'
                        call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                    endif
                    if (flexio) then
                        call tbextb(tabfl0, 'V', tabfle, 1, 'INTITULE',&
                                    'EQ', [ibid], [r8b], [cbid], kinti,&
                                    [r8b], k8b, iret)
                        if (iret .eq. 10) then
                            valk(1) = 'INTITULE'
                            valk(2) = tabfl0
                            call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                        else if (iret .eq. 20) then
                            valk(1) = tabfl0
                            valk(2) = 'INTITULE'
                            call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                        endif
                    endif
                    if (lrocht) then
                        call tbextb(tabpr0, 'V', tabpre, 1, 'INTITULE',&
                                    'EQ', [ibid], [r8b], [cbid], kinti,&
                                    [r8b], k8b, iret)
                        if (iret .eq. 10) then
                            valk(1) = 'INTITULE'
                            valk(2) = tabpr0
                            call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                        else if (iret .eq. 20) then
                            valk(1) = tabpr0
                            valk(2) = 'INTITULE'
                            call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                        endif
                    endif
                endif
                call tbexip(table, valek(1), exist, k8b)
                if (.not. exist) then
                    valk (1) = table
                    valk (2) = 'INTITULE'
                    valk (3) = kinti
                    valk (4) = valek(1)
                    call utmess('F', 'POSTRCCM_17', nk=4, valk=valk)
                endif
                call tbexv1(table, valek(1), instan, 'V', nbins0,&
                            k8b)
                call jedetr(instan)
            endif
        endif
        nbinst = nbinst + nbins0
!
! ----- PRESENCE DES COMPOSANTES DANS LA TABLE
!
        if (iocc .ne. 1) goto 14
!
        if (.not. cfait) then
            if (nbinti .eq. 1) then
                table = tabl0
                tabfle = tabfl0
                tabpre = tabpr0
            else
                cfait = .true.
                table = '&&RCEVO2.RESU_ME'
                tabfle = '&&RCEVO2.SIGM_TH'
                tabpre = '&&RCEVO2.RESU_PR'
                call tbextb(tabl0, 'V', table, 1, 'INTITULE',&
                            'EQ', [ibid], [r8b], [cbid], kinti,&
                            [r8b], k8b, iret)
                if (iret .eq. 10) then
                    valk(1) = 'INTITULE'
                    valk(2) = tabl0
                    call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                else if (iret .eq. 20) then
                    valk(1) = tabl0
                    valk(2) = 'INTITULE'
                    call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                endif
                if (flexio) then
                    call tbextb(tabfl0, 'V', tabfle, 1, 'INTITULE',&
                                'EQ', [ibid], [r8b], [cbid], kinti,&
                                [r8b], k8b, iret)
                    if (iret .eq. 10) then
                        valk(1) = 'INTITULE'
                        valk(2) = tabfl0
                        call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                    else if (iret .eq. 20) then
                        valk(1) = tabfl0
                        valk(2) = 'INTITULE'
                        call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                    endif
                endif
                if (lrocht) then
                    call tbextb(tabpr0, 'V', tabpre, 1, 'INTITULE',&
                                'EQ', [ibid], [r8b], [cbid], kinti,&
                                [r8b], k8b, iret)
                    if (iret .eq. 10) then
                        valk(1) = 'INTITULE'
                        valk(2) = tabpr0
                        call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                    else if (iret .eq. 20) then
                        valk(1) = tabpr0
                        valk(2) = 'INTITULE'
                        call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                    endif
                endif
            endif
        endif
!
        ncmpr = 6
        do 12 i = 1, 4
            call tbexip(table, nocmp(i), exist, k8b)
            if (.not. exist) then
                valk (1) = table
                valk (2) = 'INTITULE'
                valk (3) = kinti
                valk (4) = nocmp(i)
                call utmess('F', 'POSTRCCM_17', nk=4, valk=valk)
            endif
            if (flexio) then
                call tbexip(tabfle, nocmp(i), exist, k8b)
                if (.not. exist) then
                    valk (1) = tabfle
                    valk (2) = 'INTITULE'
                    valk (3) = kinti
                    valk (4) = nocmp(i)
                    call utmess('F', 'POSTRCCM_17', nk=4, valk=valk)
                endif
            endif
            if (lrocht) then
                call tbexip(tabpre, nocmp(i), exist, k8b)
                if (.not. exist) then
                    valk (1) = tabpre
                    valk (2) = 'INTITULE'
                    valk (3) = kinti
                    valk (4) = nocmp(i)
                    call utmess('F', 'POSTRCCM_17', nk=4, valk=valk)
                endif
            endif
 12     continue
        call tbexip(table, nocmp(5), exist, k8b)
        if (.not. exist) ncmpr = 4
!
! ----- ON RECUPERE L'ABSC_CURV DANS LA TABLE
!
        call tbexip(table, valek(2), exist, k8b)
        if (.not. exist) then
            valk (1) = table
            valk (2) = 'INTITULE'
            valk (3) = kinti
            valk (4) = valek(2)
            call utmess('F', 'POSTRCCM_17', nk=4, valk=valk)
        endif
        call tbexv1(table, valek(2), abscur, 'V', nbabsc,&
                    k8b)
!
 14     continue
        if (cfait) then
            call detrsd('TABLE', table)
            if (flexio) call detrsd('TABLE', tabfle)
            if (lrocht) call detrsd('TABLE', tabpre)
        endif
!
 10 end do
!
    call jeveuo(abscur, 'L', jabsc)
    AS_ALLOCATE(vr=contraintes, size=nbabsc)
    AS_ALLOCATE(vr=cont_flexio, size=nbabsc)
    AS_ALLOCATE(vr=cont_pressi, size=nbabsc)
!
! --- CREATION DES OBJETS DE TRAVAIL
!
    ndim = 6 * nbinst * ncmp
    call wkvect(csigm, 'V V R', ndim, jsigm)
    call wkvect(cinst, 'V V R', nbinst, jinst)
    call wkvect(cnoc, 'V V I', nbinst, jnocc)
    call wkvect(cresu, 'V V K8', nbinst, jresu)
    if (lfatig) then
        ndim = 2 * nbinst * ncmp
        call wkvect(csiex, 'V V R', ndim, jsioe)
        if (kemixt) then
            call wkvect(cstex, 'V V R', ndim, jstoe)
            call wkvect(csmex, 'V V R', ndim, jsmoe)
        endif
    endif
    if (lrocht) then
        call wkvect(cpres, 'V V K8', nbtran, jresp)
    endif
!
! --- RECUPERATION DES INFORMATIONS
!
    ii = 0
    do 100 iocc = 1, nbtran, 1
!
        call getvis(motclf, 'NB_OCCUR', iocc=iocc, scal=nbcycl, nbret=n1)
!
        call getvid(motclf, 'TABL_RESU_MECA', iocc=iocc, scal=tabl0, nbret=n1)
!
        flexii = .false.
        call getvid(motclf, 'TABL_SIGM_THER', iocc=iocc, scal=tabfl0, nbret=n1)
        if (n1 .ne. 0) flexii = .true.
!
        call getvid(motclf, 'TABL_RESU_PRES', iocc=iocc, scal=tabpr0, nbret=n1)
        if (n1 .ne. 0) then
            lrocht = .true.
            zk8(jresp-1+iocc) = tabpr0
        endif
!
        if (nbinti .eq. 1) then
            table = tabl0
            tabfle = tabfl0
            tabpre = tabpr0
        else
            table = '&&RCEVO2.RESU_ME'
            tabfle = '&&RCEVO2.SIGM_TH'
            tabpre = '&&RCEVO2.RESU_PR'
            call tbextb(tabl0, 'V', table, 1, 'INTITULE',&
                        'EQ', [ibid], [r8b], [cbid], kinti,&
                        [r8b], k8b, iret)
            if (iret .eq. 10) then
                valk(1) = 'INTITULE'
                valk(2) = tabl0
                call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
            else if (iret .eq. 20) then
                valk(1) = tabl0
                valk(2) = 'INTITULE'
                call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
            endif
            if (flexii) then
                call tbextb(tabfl0, 'V', tabfle, 1, 'INTITULE',&
                            'EQ', [ibid], [r8b], [cbid], kinti,&
                            [r8b], k8b, iret)
                if (iret .eq. 10) then
                    valk(1) = 'INTITULE'
                    valk(2) = tabfl0
                    call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                else if (iret .eq. 20) then
                    valk(1) = tabfl0
                    valk(2) = 'INTITULE'
                    call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                endif
            endif
            if (lrocht) then
                call tbextb(tabpr0, 'V', tabpre, 1, 'INTITULE',&
                            'EQ', [ibid], [r8b], [cbid], kinti,&
                            [r8b], k8b, iret)
                if (iret .eq. 10) then
                    valk(1) = 'INTITULE'
                    valk(2) = tabpr0
                    call utmess('F', 'UTILITAI7_1', nk=2, valk=valk)
                else if (iret .eq. 20) then
                    valk(1) = tabpr0
                    valk(2) = 'INTITULE'
                    call utmess('F', 'UTILITAI7_3', nk=2, valk=valk)
                endif
            endif
        endif
!
! ----- ON RECUPERE LES INSTANTS DANS LA TABLE
!
        call getvr8(motclf, 'INST', iocc=iocc, nbval=0, nbret=n1)
        if (n1 .ne. 0) then
            nbins0 = -n1
            call wkvect(instan, 'V V R', nbins0, kinst)
            call getvr8(motclf, 'INST', iocc=iocc, nbval=nbins0, vect=zr(kinst),&
                        nbret=n1)
            call getvr8(motclf, 'PRECISION', iocc=iocc, scal=prec(1), nbret=n1)
            call getvtx(motclf, 'CRITERE', iocc=iocc, scal=crit(1), nbret=n1)
        else
            call getvid(motclf, 'LIST_INST', iocc=iocc, scal=nomf, nbret=n1)
            if (n1 .ne. 0) then
                call jelira(nomf//'.VALE', 'LONMAX', nbins0)
                call jeveuo(nomf//'.VALE', 'L', kinst)
                call getvr8(motclf, 'PRECISION', iocc=iocc, scal=prec(1), nbret=n1)
                call getvtx(motclf, 'CRITERE', iocc=iocc, scal=crit(1), nbret=n1)
            else
                if(lfatig)then
                    call utmess('A','POSTRCCM_22')
                endif
                prec(1) = 1.0d-06
                crit(1) = 'RELATIF'
                call tbexip(table, valek(1), exist, k8b)
                if (.not. exist) then
                    valk (1) = table
                    valk (2) = 'INTITULE'
                    valk (3) = kinti
                    valk (4) = valek(1)
                    call utmess('F', 'POSTRCCM_17', nk=4, valk=valk)
                endif
                call tbexv1(table, valek(1), instan, 'V', nbins0,&
                            k8b)
                call jeveuo(instan, 'L', kinst)
            endif
        endif
!
        do 102 i = 1, nbins0
!
            ii = ii + 1
            zr (jinst+ii-1) = zr(kinst+i-1)
            zi (jnocc-1+ii) = nbcycl
            zk8(jresu-1+ii) = tabl0
!
            vale(1) = zr(kinst+i-1)
!
            do 104 j = 1, ncmpr
!
                do 106 k = 1, nbabsc
                    vale(2) = zr(jabsc+k-1)
!
                    call tbliva(table, 2, valek, [ibid], vale,&
                                [cbid], k8b, crit, prec, nocmp(j),&
                                k8b, ibid, contraintes(k), cbid, k8b,&
                                iret)
                    if (iret .ne. 0) then
                        valk (1) = table
                        valk (2) = nocmp(j)
                        valk (3) = valek(1)
                        valk (4) = valek(2)
                        call utmess('F', 'POSTRCCM_2', nk=4, valk=valk, nr=2,&
                                    valr=vale)
                    endif
!
                    if (flexii) then
                        call tbliva(tabfle, 2, valek, [ibid], vale,&
                                    [cbid], k8b, crit, prec, nocmp(j),&
                                    k8b, ibid, cont_flexio(k), cbid, k8b,&
                                    iret)
                        if (iret .ne. 0) then
                            valk (1) = tabfle
                            valk (2) = nocmp(j)
                            valk (3) = valek(1)
                            valk (4) = valek(2)
                            call utmess('F', 'POSTRCCM_2', nk=4, valk=valk, nr=2,&
                                        valr=vale)
                        endif
                    endif
!
                    if (lrocht) then
                        call tbliva(tabpre, 2, valek, [ibid], vale,&
                                    [cbid], k8b, crit, prec, nocmp(j),&
                                    k8b, ibid, cont_pressi(k), cbid, k8b,&
                                    iret)
                        if (iret .ne. 0) then
                            valk (1) = tabpre
                            valk (2) = nocmp(j)
                            valk (3) = valek(1)
                            valk (4) = valek(2)
                            call utmess('F', 'POSTRCCM_2', nk=4, valk=valk, nr=2,&
                                        valr=vale)
                        endif
                    endif
!
106             continue
!
                if (lfatig) then
                    lo = ncmp*(ii-1) + j
                    le = ncmp*nbinst + ncmp*(ii-1) + j
                    zr(jsioe-1+lo) = contraintes(1)
                    zr(jsioe-1+le) = contraintes(nbabsc)
                    if (kemixt) then
                        if (flexii) then
                            zr(jstoe-1+lo) = cont_flexio(1)
                            zr(jstoe-1+le) = cont_flexio(nbabsc)
                        else
                            zr(jstoe-1+lo) = 0.d0
                            zr(jstoe-1+le) = 0.d0
                        endif
                        zr(jsmoe-1+lo) = contraintes(1) - zr(jstoe-1+lo)
                        zr(jsmoe-1+le) = contraintes(nbabsc) - zr( jstoe-1+le)
                    endif
                endif
!
                call rc32my(nbabsc, zr(jabsc), contraintes, momen0, momen1)
                momen1 = 0.5d0*momen1
!
                l = ncmp*(ii-1) + j
                zr(jsigm-1+l) = momen0
                l = ncmp*nbinst + ncmp*(ii-1) + j
                zr(jsigm-1+l) = momen1
!
                if (flexii) then
                    call rc32my(nbabsc, zr(jabsc), cont_flexio, momen0, momen1)
                    momen1 = 0.5d0*momen1
                else
                    momen0 = 0.d0
                    momen1 = 0.d0
                endif
                l = 2*ncmp*nbinst + ncmp*(ii-1) + j
                zr(jsigm-1+l) = momen0
                l = 3*ncmp*nbinst + ncmp*(ii-1) + j
                zr(jsigm-1+l) = momen1
!
                if (lrocht) then
                    call rc32my(nbabsc, zr(jabsc), cont_pressi, momen0, momen1)
                    momen1 = 0.5d0*momen1
                else
                    momen0 = r8vide()
                    momen1 = r8vide()
                endif
                l = 4*ncmp*nbinst + ncmp*(ii-1) + j
                zr(jsigm-1+l) = momen0
                l = 5*ncmp*nbinst + ncmp*(ii-1) + j
                zr(jsigm-1+l) = momen1
!
104         continue
!
102     continue
        call jedetr(instan)
        if (nbinti .ne. 1) then
            call detrsd('TABLE', table)
            if (flexii) call detrsd('TABLE', tabfle)
            if (lrocht) call detrsd('TABLE', tabpre)
        endif
!
100 end do
!
    call jedetr(abscur)
    AS_DEALLOCATE(vr=contraintes)
    AS_DEALLOCATE(vr=cont_flexio)
    AS_DEALLOCATE(vr=cont_pressi)
!
9999 continue
    call jedema()
end subroutine
