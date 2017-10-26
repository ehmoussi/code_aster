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

subroutine rc32t2()
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterc/getfac.h"
#include "asterfort/jecrec.h"
#include "asterfort/getvis.h"
#include "asterfort/getvid.h"
#include "asterfort/rcveri.h"
#include "asterfort/tbexip.h"
#include "asterfort/utmess.h"
#include "asterfort/tbexv1.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rcver1.h"
#include "asterfort/as_allocate.h"
#include "asterfort/jecroc.h"
#include "asterfort/jeecra.h"
#include "asterfort/jexnum.h"
#include "asterfort/tbliva.h"
#include "asterfort/rc32my.h"
#include "asterfort/rctres.h"
#include "asterfort/trace.h"
#include "asterfort/jedetr.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jedema.h"
#include "asterfort/getvtx.h"

!     ------------------------------------------------------------------
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_ZE200 et B3200
!     STOCKAGE DES CONTRAINTES TOTALES ET LINEARISEES :
!                 - THERMIQUES SOUS "RESU_THER"
!                 - DE PRESSION SOUS "RESU_PRES"
!                 - DUS AUX EFFORTS ET MOMENTS SOUS "RESU_MECA"
!     ------------------------------------------------------------------
!
    integer :: nbsitu, nbther, nbpres, nbmeca, iocc
    character(len=24) :: jvorig, jvextr, valk(4)
    character(len=8) :: nocmp(6), crit(2), tabther, tabpres
    character(len=16) :: valek(2), methode
    integer :: nume1, n1, nume2, n2, nume3, n3, nn, ither, numether
    integer :: n5, ipres, numepres, imeca, numemeca, nbinst, jinst
    character(len=8) :: tabmeca, tableok, k8b, tabtemp
    aster_logical :: exist
    integer :: nbabsc, jabsc, ncmp, ndim, jorig, jextr, k, i, j
    real(kind=8) :: prec(2)
    real(kind=8) :: vale(2), momen0, momen1, momen0ther, momen1ther
    real(kind=8) :: momen0pres, momen1pres, momen0mec, momen1mec, temp
    real(kind=8) :: verifori, verifextr
    integer :: ibid, iret, n4, jtemp, nb, l
    complex(kind=8) :: cbid
    real(kind=8), pointer :: contraintesth(:) => null()
    real(kind=8), pointer :: contraintespr(:) => null()
    real(kind=8), pointer :: contraintestot(:) => null()
    real(kind=8), pointer :: contraintesmec(:) => null()
! DEB ------------------------------------------------------------------
    call jemarq()
!
    call getvtx(' ', 'METHODE', scal=methode, nbret=nb)
    if (methode .ne. 'TOUT_INST') goto 999
!
    call getfac('SITUATION', nbsitu)
!
    jvorig = '&&RC3200.TRANSIT.ORIG'
    jvextr = '&&RC3200.TRANSIT.EXTR'
    call jecrec(jvorig, 'V V R', 'NU', 'DISPERSE', 'VARIABLE',&
                nbsitu)
    call jecrec(jvextr, 'V V R', 'NU', 'DISPERSE', 'VARIABLE',&
                nbsitu)
    call jecrec('&&RC3200.TEMPCST', 'V V R', 'NU', 'DISPERSE', 'VARIABLE',&
                nbsitu)
!
    call getfac('RESU_THER', nbther)
    call getfac('RESU_PRES', nbpres)
    call getfac('RESU_MECA', nbmeca)
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
    l = 0
!
    do 10 iocc = 1, nbsitu, 1
!
!------ on récupère les numéros des tables sous le mot clé situation 
!------ puis les tables associées sous RESU_THER, RESU_PRES et RESU_MECA 
        call getvis('SITUATION', 'NUME_RESU_THER', iocc=iocc, scal=nume1, nbret=n1)
        call getvis('SITUATION', 'NUME_RESU_PRES', iocc=iocc, scal=nume2, nbret=n2)
        call getvis('SITUATION', 'NUME_RESU_MECA', iocc=iocc, scal=nume3, nbret=n3)
        call getvid('SITUATION', 'TABL_TEMP', iocc=iocc, scal=tabtemp, nbret=n4)
        nn= n1+n2+n3
        if((nn+n4) .eq. 0) goto 888
!
        if (n1 .ne. 0) then 
            do 20 ither =1, nbther, 1
                call getvis('RESU_THER', 'NUME_RESU_THER', iocc=ither, scal=numether, nbret=n5)
                if (numether .eq. nume1) then
                    call getvid('RESU_THER', 'TABL_RESU_THER', iocc=ither, scal=tabther, nbret=n5)
                endif
20          continue
        endif
!
        if (n2 .ne. 0) then 
            do 30 ipres =1, nbpres, 1
                call getvis('RESU_PRES', 'NUME_RESU_PRES', iocc=ipres, scal=numepres, nbret=n5)
                if (numepres .eq. nume2) then
                    call getvid('RESU_PRES', 'TABL_RESU_PRES', iocc=ipres, scal=tabpres, nbret=n5)
                endif
30          continue
        endif
!
        if (n3 .ne. 0) then 
            do 40 imeca =1, nbmeca, 1
                call getvis('RESU_MECA', 'NUME_RESU_MECA', iocc=imeca, scal=numemeca, nbret=n5)
                if (numemeca .eq. nume3) then
                    call getvid('RESU_MECA', 'TABL_RESU_MECA', iocc=imeca, scal=tabmeca, nbret=n5)
                endif
40          continue
        endif
!----------------------------------------------------
! ------ RECUPERATION DES INSTANTS ET DES ABSCISSES
!----------------------------------------------------
! ------ grace a la table thermique ou de pression ou mecanique
        if (n1 .ne. 0) then
            tableok = tabther
        elseif (n2 .ne. 0) then
            tableok = tabpres
        elseif (n3 .ne. 0) then
            tableok = tabmeca
        else
            tableok = tabtemp
        endif
!  
! --------- on verifie l'ordre des noeuds de la table
        call rcveri(tableok)
! 
! --------- on recupere les instants de la table
        call tbexip(tableok, valek(1), exist, k8b)
        if (.not. exist) then
            valk (1) = tableok
            valk (2) = valek(1)
            call utmess('F', 'POSTRCCM_1', nk=2, valk=valk)
        endif
        call tbexv1(tableok, valek(1), 'RC.INSTANT', 'V', nbinst,&
                    k8b)
        call jeveuo('RC.INSTANT', 'L', jinst)
!
! --------- on recupere les abscisses curvilignes de la table
        call tbexip(tableok, valek(2), exist, k8b)
        if (.not. exist) then
            valk (1) = tableok
            valk (2) = valek(2)
            call utmess('F', 'POSTRCCM_1', nk=2, valk=valk)
        endif
        call tbexv1(tableok, valek(2), 'RC.ABSC', 'V', nbabsc,&
                    k8b)
        call jeveuo('RC.ABSC', 'L', jabsc)
!
! --------- on vérifie que toutes les situations sont definies sur les mêmes abscisses
        l = l+1
        if(l .eq. 1) verifori = zr(jabsc)
        if(l .eq. 1) verifextr = zr(jabsc+nbabsc-1)
        if(l .gt. 1) then
            if (abs(verifori-zr(jabsc)) .gt. 1e-8) call utmess('F', 'POSTRCCM_45')
            if (abs(verifextr-zr(jabsc+nbabsc-1)) .gt. 1e-8) call utmess('F', 'POSTRCCM_45')
        endif
!
! ------ ON VERIFIE LA COHERENCE DES TABLES (THERMIQUE, PRESSION ET MECA)
        if (n1 .ne. 0) then
            if (n2 .ne. 0) then
                call rcver1('MECANIQUE', tabpres, tabther)
            endif
            if (n3 .ne. 0) then
                call rcver1('MECANIQUE', tabmeca, tabther)
            endif
        endif
        if (n2 .ne. 0) then
            if (n3 .ne. 0) then
                call rcver1('MECANIQUE', tabmeca, tabpres)
            endif
        endif
!
        if (nn .eq. 0) then
            if (n4 .ne. 0) then
                call jecroc(jexnum('&&RC3200.TEMPCST', iocc))
                call jeecra(jexnum('&&RC3200.TEMPCST', iocc), 'LONMAX', 2)
                call jeecra(jexnum('&&RC3200.TEMPCST', iocc), 'LONUTI', 2)
                call jeveuo(jexnum('&&RC3200.TEMPCST', iocc), 'E', jtemp)
!
                vale(1)= zr(jinst)
                vale(2)= zr(jabsc)
                call tbliva(tabtemp, 2, valek, [ibid], vale,&
                            [cbid], k8b, crit, prec, 'TEMP',&
                            k8b, ibid, zr(jtemp), cbid, k8b,&
                            iret)
                if (iret .ne. 0) then
                    valk (1) = tabtemp
                    valk (2) = 'TEMP'
                    valk (3) = valek(1)
                    valk (4) = valek(2)
                    call utmess('F', 'POSTRCCM_2', nk=4, valk=valk, nr=2,&
                                 valr=vale)
                endif
!
                vale(1)= zr(jinst)
                vale(2)= zr(jabsc+nbabsc-1)
                call tbliva(tabtemp, 2, valek, [ibid], vale,&
                            [cbid], k8b, crit, prec, 'TEMP',&
                            k8b, ibid, zr(jtemp+1), cbid, k8b,&
                            iret)
                if (iret .ne. 0) then
                    valk (1) = tabtemp
                    valk (2) = 'TEMP'
                    valk (3) = valek(1)
                    valk (4) = valek(2)
                    call utmess('F', 'POSTRCCM_2', nk=4, valk=valk, nr=2,&
                                 valr=vale)
                endif
            endif
            goto 888
        endif
!---------------------------------------------------------------
! ------ on stocke d'abord le nombre d'instant total, puis l'instant calculé
! ------ puis CREATION DES nbinst*8 TABLES A 6 composantes de contraintes
! ------ (totales puis pression+meca puis lin. totales puis pression moyenne  )
! ------ (puis lin. ther. + lin. pres. + lin. meca puis flex. ther )
! ------ puis CREATION DE nbinst*1 TABLE A 1 composante de température
!---------------------------------------------------------------
!
        AS_ALLOCATE(vr=contraintesth,  size=nbabsc)
        AS_ALLOCATE(vr=contraintespr,  size=nbabsc)
        AS_ALLOCATE(vr=contraintesmec, size=nbabsc)
        AS_ALLOCATE(vr=contraintestot, size=nbabsc)
!
        ncmp=6
        ndim = 1+nbinst+nbinst * 8 * ncmp + nbinst*1*1
        call jecroc(jexnum(jvorig, iocc))
        call jeecra(jexnum(jvorig, iocc), 'LONMAX', ndim)
        call jeecra(jexnum(jvorig, iocc), 'LONUTI', ndim)
        call jeveuo(jexnum(jvorig, iocc), 'E', jorig)
!
        call jecroc(jexnum(jvextr, iocc))
        call jeecra(jexnum(jvextr, iocc), 'LONMAX', ndim)
        call jeecra(jexnum(jvextr, iocc), 'LONUTI', ndim)
        call jeveuo(jexnum(jvextr, iocc), 'E', jextr)
!
        zr(jorig) = nbinst
        zr(jextr) = nbinst
!
        do 100 i = 1, nbinst
          vale(1) = zr(jinst-1+i)
!
!-------- on vérifie que tous les instants sont dans l'ordre croissant
          if (i .gt. 1) then
              if(vale(1) .le. zr(jinst-1+i-1)) call utmess('A', 'POSTRCCM_55')
          endif
          zr(jorig+50*(i-1)+1)= zr(jinst-1+i)
          zr(jextr+50*(i-1)+1)= zr(jinst-1+i)
!
          do 66 j = 1, ncmp
!
            do 167 k = 1, nbabsc
                vale(2) = zr(jabsc-1+k)
                if (n1 .ne. 0) then
                    call tbliva(tabther, 2, valek, [ibid], vale,&
                                [cbid], k8b, crit, prec, nocmp(j),&
                                k8b, ibid, contraintesth(k), cbid, k8b,&
                                iret)
                endif
                if (n2 .ne. 0) then
                    call tbliva(tabpres, 2, valek, [ibid], vale,&
                                [cbid], k8b, crit, prec, nocmp(j),&
                                k8b, ibid, contraintespr(k), cbid, k8b,&
                                iret)
                endif
                if (n3 .ne. 0) then
                    call tbliva(tabmeca, 2, valek, [ibid], vale,&
                                [cbid], k8b, crit, prec, nocmp(j),&
                                k8b, ibid, contraintesmec(k), cbid, k8b,&
                                iret)
                endif
                contraintestot(k)=contraintesth(k)+contraintespr(k)+contraintesmec(k)
 167        continue
            zr(jorig+50*(i-1)+1+j) = contraintestot(1)
            zr(jorig+50*(i-1)+1+6+j) = contraintespr(1)+contraintesmec(1)
            zr(jextr+50*(i-1)+1+j) = contraintestot(nbabsc)
            zr(jextr+50*(i-1)+1+6+j) = contraintespr(nbabsc)+contraintesmec(nbabsc)
!
            call rc32my(nbabsc, zr(jabsc), contraintestot, momen0, momen1)
            call rc32my(nbabsc, zr(jabsc), contraintesth, momen0ther, momen1ther)
            call rc32my(nbabsc, zr(jabsc), contraintespr, momen0pres, momen1pres)
            call rc32my(nbabsc, zr(jabsc), contraintesmec, momen0mec, momen1mec)
!
            zr(jorig+50*(i-1)+1+12+j) = momen0 - 0.5d0*momen1
            zr(jorig+50*(i-1)+1+18+j) = momen0pres 
            zr(jorig+50*(i-1)+1+24+j) = momen0ther - 0.5d0*momen1ther
            zr(jorig+50*(i-1)+1+30+j) = momen0pres - 0.5d0*momen1pres
            zr(jorig+50*(i-1)+1+36+j) = momen0mec - 0.5d0*momen1mec
            zr(jorig+50*(i-1)+1+42+j) = - 0.5d0*momen1ther
!
            zr(jextr+50*(i-1)+1+12+j) = momen0 + 0.5d0*momen1
            zr(jextr+50*(i-1)+1+18+j) = momen0pres 
            zr(jextr+50*(i-1)+1+24+j) = momen0ther + 0.5d0*momen1ther
            zr(jextr+50*(i-1)+1+30+j) = momen0pres + 0.5d0*momen1pres
            zr(jextr+50*(i-1)+1+36+j) = momen0mec + 0.5d0*momen1mec
            zr(jextr+50*(i-1)+1+42+j) = + 0.5d0*momen1ther
!
66        continue
!
          vale(2) = zr(jabsc)
          zr(jorig+50*(i-1)+1+48) = 0.d0
          if (n4 .ne. 0) then
              call tbliva(tabtemp, 2, valek, [ibid], vale,&
                          [cbid], k8b, crit, prec, 'TEMP',&
                          k8b, ibid, temp, cbid, k8b,&
                          iret)
              if (iret .ne. 0) then
                  valk (1) = tabtemp
                  valk (2) = 'TEMP'
                  valk (3) = valek(1)
                  valk (4) = valek(2)
                  call utmess('F', 'POSTRCCM_2', nk=4, valk=valk, nr=2,&
                               valr=vale)
              endif
              zr(jorig+50*(i-1)+1+48+1) = temp
          endif
!
          vale(2) = zr(jabsc-1+nbabsc)
          zr(jextr+50*(i-1)+1+48) = 0.d0
          if (n4 .ne. 0) then
              call tbliva(tabtemp, 2, valek, [ibid], vale,&
                          [cbid], k8b, crit, prec, 'TEMP',&
                          k8b, ibid, temp, cbid, k8b,&
                          iret)
              if (iret .ne. 0) then
                  valk (1) = tabtemp
                  valk (2) = 'TEMP'
                  valk (3) = valek(1)
                  valk (4) = valek(2)
                  call utmess('F', 'POSTRCCM_2', nk=4, valk=valk, nr=2,&
                               valr=vale)
              endif
              zr(jextr+50*(i-1)+1+48+1) = temp
          endif
100     continue
!
        call jedetr('RC.INSTANT')
        call jedetr('RC.ABSC')
        AS_DEALLOCATE(vr=contraintesmec)
        AS_DEALLOCATE(vr=contraintesth)
        AS_DEALLOCATE(vr=contraintespr)
        AS_DEALLOCATE(vr=contraintestot)
!
 888    continue
 10 continue
!
999 continue
    call jedema()
end subroutine
