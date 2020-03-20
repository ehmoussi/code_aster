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
!
subroutine lect58(fileUnit   ,&
                  resultName , resultType , meshAst,&
                  fieldNb    , fieldList  ,&
                  storeAccess,&
                  storeIndxNb, storeTimeNb,&
                  storeIndx  , storeTime  ,&
                  storeCrit  , storeEpsi)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/cnscno.h"
#include "asterfort/cnscre.h"
#include "asterfort/codent.h"
#include "asterfort/codnop.h"
#include "asterfort/decod2.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/gnomsd.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/lectvl.h"
#include "asterfort/numeok.h"
#include "asterfort/reliem.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/ulisop.h"
#include "asterfort/ulopen.h"
!
integer, intent(in) :: fileUnit
character(len=8), intent(in) :: resultName
character(len=16), intent(in) :: resultType
character(len=8), intent(in) :: meshAst
integer, intent(in) :: fieldNb
character(len=16), intent(in) :: fieldList(100)
character(len=10), intent(in) :: storeAccess
integer, intent(in) :: storeIndxNb, storeTimeNb
character(len=19), intent(in) :: storeIndx, storeTime
real(kind=8), intent(in) :: storeEpsi
character(len=8), intent(in) :: storeCrit
!
! --------------------------------------------------------------------------------------------------
!
! IDEAS reader
!
! Read field - Only DATASET 58
!
! --------------------------------------------------------------------------------------------------
!
! In  fileUnit         : index of file (logical unit)
! In  resultName       : name of results datastructure
! In  resultType       : type of results datastructure (EVOL_NOLI, EVOL_THER, )
! In  model            : name of model
! In  meshAst          : name of (aster) mesh
! In  fieldNb          : number of fields to read
! In  fieldList        : list of fields to read
! In  storeAccess      : how to access to the storage
! In  storeIndxNb      : number of storage slots given by index (integer)
! In  storeIndx        : name of JEVEUX object to access storage slots given by index (integer)
! In  storeTimeNb      : number of storage slots given by time/freq (real)
! In  storeTime        : name of JEVEUX object to access storage slots given by time/freq (real)
! In  storeEpsi        : tolerance to find time/freq (real)
! In  storeCrit        : type of tolerance to find time/freq (real)
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: astock
    character(len=1) :: prfnoe
    character(len=6) :: kar
    character(len=8) :: k8bid, labk8, nomgd, licmp(30)
    character(len=16) :: fileType, motcle(1), tymocl(1), fileName
    character(len=19) :: cns, nomch, prfchn
    character(len=24) :: vabs, vori, vcor, valmes, noojb
    character(len=80) :: ligne, repem1, rec(20)
    integer :: nbabs, itype, idir, nbnmes, ichamp, nbmesu
    integer :: vali, iField, icham0
    integer :: label, lcorr, ibid, lori
    integer :: nbrec, nbabs1, inatur, inatu1, numefield
    integer :: lvalc, lvalr, labs
    integer :: irec, iret, ifres
    integer :: nbocc, iocc, nbno2, iagno2, i, icmpm
    integer :: fileIndx, jcnsv, jcnsl, imes, icmp, ino, ival, jabs, ncmp
    real(kind=8) :: amin, apas, rbid, fileTime, dir(3)
    complex(kind=8) :: cval, czero, cun
    aster_logical :: trouve, zcmplx, ficab, ficva, vucont, vudef
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    icham0 = 0
    inatu1 = 0
    nbabs1 = 0
    prfnoe='N'
!
    repem1 (  1 : 50 ) = '    -1                                            '
    repem1 ( 51 : 80 ) = '                              '
    cval = dcmplx(0.d0,0.d0)
    czero = dcmplx(0.d0,0.d0)
    cun = dcmplx(1.d0,0.d0)
    ficab = .false.
    ficva = .false.
    vabs = '&&ABSCISSES'
    vori = '&&ORIENTATIONS'
    vcor = '&&CORRESPONDANCE'
    valmes = '&&VALEURSMESUREES'
    cns = '&&CNS'
!
! - Open file
!
    fileName = ' '
    if (ulisop(fileUnit, fileName) .eq. 0) then
        call ulopen(fileUnit, ' ', ' ', 'NEW', 'O')
    endif
!
! RECUPERATION DU NOMBRE DE NOEUDS DU MAILLAGE : NBNMES
    call dismoi('NB_NO_MAILLA', meshAst, 'MAILLAGE', repi=nbnmes)
!
! VECTEUR DES NUMEROS DES NOEUDS MESURE SELON L ORDRE FICHIER UNV
    call wkvect(vcor, 'V V I', nbnmes*6, lcorr)
!
! VECTEUR DES ORIENTATIONS DE MESURE SELON L ORDRE DU FICHIER UNV
    call wkvect(vori, 'V V I', nbnmes*6, lori)
!
!  BOUCLE SUR LES CHAMPS
    do iField = 1, fieldNb
        nbmesu = 0
        fileType = fieldList(iField)
        if (fileType .eq. 'SIEF_NOEU') icham0 = 2
        if (fileType .eq. 'EPSI_NOEU') icham0 = 3
        if (fileType .eq. 'DEPL') icham0 = 8
        if (fileType .eq. 'VITE') icham0 = 11
        if (fileType .eq. 'ACCE') icham0 = 12
!
        rewind fileUnit
!
 10     continue
        read (fileUnit, 780, end = 170) ligne
        if (ligne .ne. repem1) goto 10
!
        read (fileUnit, '(A6)', end = 170, err = 160) kar
        if (kar .eq. '    58') then
            nbrec = 11
        else
! POSITIONNEMENT A LA FIN DU DATASET
            goto 11
        endif
!
! LECTURE DE L'ENTETE DU DATASET
        do irec = 1, nbrec
            read (fileUnit,'(A80)',err=160) rec(irec)
        end do
!
! RECHERCHE DU NOMBRE DE VALEURS CONTENUES DANS LE DATASET
        irec = 7
        numefield = 2
        call decod2(rec, irec, numefield, 0, nbabs,&
                    rbid, trouve)
        if (.not. ficab) then
            call wkvect(vabs, 'V V R', nbabs, labs)
            nbabs1 = nbabs
            ficab = .true.
        else
            if (nbabs .ne. nbabs1) then
                call utmess('F', 'ALGORITH4_98')
            endif
        endif
!
!- RECHERCHE DE LA NATURE DU CHAMP
!   REEL     --> INATUR = 2,4
!   COMPLEXE --> INATUR = 5,6
        numefield = 1
        call decod2(rec, irec, numefield, 0, inatur,&
                    rbid, trouve)
        if (nbmesu .eq. 0) then
            inatu1 = inatur
        else
            if (inatur .ne. inatu1) then
                call utmess('F', 'ALGORITH4_99')
            endif
        endif
        if (inatur .eq. 5 .or. inatur .eq. 6) then
            if (resultType(1:6) .eq. 'DYNA_T') then
                call utmess('F', 'ALGORITH5_1')
            endif
            zcmplx = .true.
            if (.not. ficva) then
                call wkvect(valmes, 'V V C', nbabs*nbnmes*3, lvalc)
                ficva = .true.
            endif
        else
            if (resultType(1:6) .eq. 'DYNA_H') then
                call utmess('F', 'ALGORITH5_2')
            endif
            zcmplx = .false.
            if (.not. ficva) then
                call wkvect(valmes, 'V V R', nbabs*nbnmes*3, lvalr)
                ficva = .true.
            endif
        endif
!
! RECUPERATION RANGEMENT DES VALEURS : EVEN / UNEVEN : ITYPE
        numefield = 3
        call decod2(rec, irec, numefield, 0, itype,&
                    rbid, trouve)
        if (itype .eq. 1) then
! RECUPERATION ABSCISSE MIN ET PAS : AMIN APAS
            numefield = 4
            call decod2(rec, irec, numefield, 1, ibid,&
                        amin, trouve)
            numefield = 5
            call decod2(rec, irec, numefield, 1, ibid,&
                        apas, trouve)
        endif
!
! LECTURE DU TYPE DU CHAMP
        irec = 9
        numefield = 1
        call decod2(rec, irec, numefield, 0, ichamp,&
                    rbid, trouve)
!
        if (ichamp .ne. icham0) goto 11
!
        if (ichamp .eq. 2) then
            if (nbmesu .eq. 0) then
                ncmp = 6
                licmp(1) = 'SIXX'
                licmp(2) = 'SIYY'
                licmp(3) = 'SIZZ'
                licmp(4) = 'SIXY'
                licmp(5) = 'SIXZ'
                licmp(6) = 'SIYZ'
                if (zcmplx) then
                    nomgd = 'SIEF_C'
                else
                    nomgd = 'SIEF_R'
                endif
            endif
        endif
        if (ichamp .eq. 3) then
            if (nbmesu .eq. 0) then
                ncmp = 6
                licmp(1) = 'EPXX'
                licmp(2) = 'EPYY'
                licmp(3) = 'EPZZ'
                licmp(4) = 'EPXY'
                licmp(5) = 'EPXZ'
                licmp(6) = 'EPYZ'
                if (zcmplx) then
                    call utmess('F', 'ALGORITH5_3')
                else
                    nomgd = 'EPSI_R'
                endif
            endif
        endif
        if (ichamp .eq. 8 .or. ichamp .eq. 11 .or. ichamp .eq. 12) then
            if (nbmesu .eq. 0) then
                ncmp = 12
                licmp(1) = 'D1'
                licmp(2) = 'D2'
                licmp(3) = 'D3'
                licmp(4) = 'D1X'
                licmp(5) = 'D1Y'
                licmp(6) = 'D1Z'
                licmp(7) = 'D2X'
                licmp(8) = 'D2Y'
                licmp(9) = 'D2Z'
                licmp(10) = 'D3X'
                licmp(11) = 'D3Y'
                licmp(12) = 'D3Z'
                if (zcmplx) then
                    nomgd = 'DEPL_C'
                else
                    nomgd = 'DEPL_R'
                endif
            endif
        endif
!
        nbmesu = nbmesu + 1
!
        if (nbmesu .gt. nbnmes*6) then
            call utmess('F', 'ALGORITH5_4')
        endif
!
! LECTURE DU NUMERO DU NOEUD
        irec = 6
        numefield = 6
        call decod2(rec, irec, numefield, 0, label,&
                    rbid, trouve)
        if (label .eq. 0) then
            ligne = rec(irec)
            labk8 = ligne(32:41)
            call jenonu(jexnom (meshAst//'.NOMNOE', labk8), label)
        else
! PRE_IDEAS RAJOUTE UN 'N' DEVANT LE NUMERO DU NOEUD (VOIR ECRNEU)
            call codnop(labk8, prfnoe, 1, 1)
            call codent(label, 'G', labk8(2:8))
            call jenonu(jexnom (meshAst//'.NOMNOE', labk8), label)
        endif
        zi(lcorr-1 + nbmesu) = label
!
! LECTURE DU CODE DE LA DIRECTION DE MESURE
        irec = 6
        numefield = 7
        call decod2(rec, irec, numefield, 0, idir,&
                    rbid, trouve)
        zi(lori-1 +nbmesu) = idir
!
! LECTURE DES VALEURS
        call lectvl(zcmplx, itype, nbabs, inatur, fileUnit,&
                    nbmesu, labs, amin, apas, lvalc,&
                    lvalr)
!
        read (fileUnit, 780, end = 170) ligne
        if (ligne .ne. repem1) then
            vali = nbmesu
            call utmess('F', 'ALGORITH15_98', si=vali)
        endif
!
        goto 10
!
160     continue
! EN CAS D ERREUR DE LECTURE DU FICHIER UNV
        call utmess('F', 'ALGORITH5_5')
!
 11     continue
! POSITIONNEMENT A LA FIN DU DATASET
        read ( fileUnit , 780 , end = 170 ) ligne
        if (ligne .ne. repem1) goto 11
        goto 10
!
170     continue
! FIN LECTURE FICHIER UNV
!
        ifres = iunifi ('MESSAGE')
        write(ifres,101) fileType,nbmesu
101     format('NOM_CHAM : ',a16,'NOMBRE DE MESURES : ',i6)
        if (nbmesu .eq. 0) then
            write(ifres,102) fileType
102         format('AUCUN CHAMP ',a16,' TROUVE')
            call utmess('A', 'ALGORITH5_6')
            goto 999
        endif
!
! CREATION DE SD_RESULTAT DYNA_TRANS / DYNA_HARMO / HARM_GENE : TYPRES
        if ((zcmplx) .and. (resultType(1:6) .eq. 'DYNA_T')) then
            call utmess('F', 'ALGORITH5_1')
        endif
!
        if ((.not.zcmplx) .and. (resultType(1:6) .ne. 'DYNA_T')) then
            call utmess('F', 'ALGORITH5_2')
        endif
!
        if (iField .eq. 1) call rsagsd(resultName, nbabs)
        noojb='12345678.00000.NUME.PRNO'
        call gnomsd(' ', noojb, 10, 14)
        prfchn=noojb(1:19)
!
        vudef = .false.
        vucont = .false.
        do fileIndx = 1, nbabs
            fileTime = zr(labs-1 +fileIndx)
! --------- Check if field from file is in the selection list
            call numeok(storeAccess,&
                        storeIndxNb, storeTimeNb,&
                        storeIndx  , storeTime  ,&
                        storeCrit  , storeEpsi  ,&
                        fileIndx   , fileTime   ,&
                        astock)
            !call numeok(storeAccess, fileIndx, fileTime, listr8, listis,&
            !            precis, storeCrit, storeEpsi, astock)
            if (astock) then
                call cnscre(meshAst, nomgd, ncmp, licmp, 'V', cns)
                call jeveuo(cns//'.CNSV', 'E', jcnsv)
                call jeveuo(cns//'.CNSL', 'E', jcnsl)
                do imes = 1, nbmesu
                    icmp = zi(lori-1 + imes)
                    ival = nbabs*(imes-1) + fileIndx
                    ino = zi(lcorr-1 + imes)
                    if (zcmplx) then
                        cval = zc(lvalc-1 +ival)
                    else
                        fileTime = zr(lvalr-1 +ival)
                    endif
                    if (icmp .lt. 0) then
                        icmp = -icmp
                        if (zcmplx) then
                            cval = -cval
                        else
                            fileTime = -fileTime
                        endif
                    endif
                    if (nomgd(1:4) .eq. 'DEPL') then
! ON SUPPOSE QUE ICMP EST COMPRIS ENTRE -3 ET 3
                        idir = (ino-1)*ncmp + (icmp-1)*3 + 3
                        if (zcmplx) then
                            zc(jcnsv-1 + (ino-1)*ncmp+icmp) = cval
                            zc(jcnsv-1 + idir+1) = czero
                            zc(jcnsv-1 + idir+2) = czero
                            zc(jcnsv-1 + idir+3) = czero
                            zc(jcnsv-1 + idir+icmp) = cun
                        else
                            zr(jcnsv-1 + (ino-1)*ncmp+icmp) = fileTime
                            zr(jcnsv-1 + idir+1) = 0.d0
                            zr(jcnsv-1 + idir+2) = 0.d0
                            zr(jcnsv-1 + idir+3) = 0.d0
                            zr(jcnsv-1 + idir+icmp) = 1.d0
                        endif
                        zl(jcnsl-1 + (ino-1)*ncmp+icmp) = .true.
                        zl(jcnsl-1 + idir+1) = .true.
                        zl(jcnsl-1 + idir+2) = .true.
                        zl(jcnsl-1 + idir+3) = .true.
!
! TRAITEMENT DES ORIENTATIONS POUR DEPL
                        call getfac('REDEFI_ORIENT', nbocc)
                        if (nbocc .gt. 0) then
                            do iocc = 1, nbocc
                                motcle(1) = 'NOEUD'
                                tymocl(1) = 'NOEUD'
                                call reliem(' ', meshAst, 'NU_NOEUD', 'REDEFI_ORIENT', iocc,&
                                            1, motcle, tymocl, '&&DEFDIR', nbno2)
                                call jeveuo('&&DEFDIR', 'L', iagno2)
                                do i = 1, nbno2
                                    if (zi(iagno2-1 +i) .eq. ino) then
                                        call getvis('REDEFI_ORIENT', 'CODE_DIR', iocc=iocc,&
                                                    scal=icmpm, nbret=ibid)
                                        if (icmp .eq. icmpm) then
                                            call getvr8('REDEFI_ORIENT', 'DIRECTION', iocc=iocc,&
                                                        nbval=3, vect=dir, nbret=ibid)
                                            if (zcmplx) then
                                                zc(jcnsv-1 + idir+1) = dcmplx( dir(1),0.d0)
                                                zc(jcnsv-1 + idir+2) = dcmplx( dir(2),0.d0)
                                                zc(jcnsv-1 + idir+3) = dcmplx( dir(3),0.d0)
                                            else
                                                zr(jcnsv-1 + idir+1) = dir(1)
                                                zr(jcnsv-1 + idir+2) = dir(2)
                                                zr(jcnsv-1 + idir+3) = dir(3)
                                            endif
                                        endif
                                    endif
                                end do
                                call jedetr('&&DEFDIR')
                            end do
                        endif
! FIN TRAITEMENT DES ORIENTATIONS POUR DEPL
                    endif
!
                    if (nomgd(1:4) .eq. 'SIEF') then
                        call getfac('REDEFI_ORIENT', nbocc)
                        if ((nbocc.gt.0) .and. (.not. vucont)) then
                            call utmess('A', 'ALGORITH5_9')
                            vucont = .true.
                        endif
                        if (zcmplx) then
                            zc(jcnsv-1 + (ino-1)*ncmp+icmp) = cval
                        else
                            zr(jcnsv-1 + (ino-1)*ncmp+icmp) = fileTime
                        endif
                        zl(jcnsl-1 + (ino-1)*ncmp+icmp) = .true.
                    endif
!
                    if (nomgd(1:4) .eq. 'EPSI') then
                        call getfac('REDEFI_ORIENT', nbocc)
                        if ((nbocc.gt.0) .and. (.not. vudef)) then
                            call utmess('A', 'ALGORITH5_10')
                            vudef = .true.
                        endif
                        zr(jcnsv-1 + (ino-1)*ncmp+icmp) = fileTime
                        zl(jcnsl-1 + (ino-1)*ncmp+icmp) = .true.
                    endif
                end do
!
! RECUPERATION DU NOM DU CHAMP POUR NUMORD : NOMCH
                call rsexch(' ', resultName, fileType, fileIndx, nomch,&
                            iret)
                call cnscno(cns, prfchn, 'NON', 'G', nomch,&
                            'F', ibid)
!
                call rsnoch(resultName, fileType, fileIndx)
                if (zcmplx) then
                    call rsadpa(resultName, 'E', 1, 'FREQ', fileIndx,&
                                0, sjv=jabs, styp=k8bid)
                else
                    call rsadpa(resultName, 'E', 1, 'INST', fileIndx,&
                                0, sjv=jabs, styp=k8bid)
                endif
                zr(jabs) = zr(labs-1 + fileIndx)
                call detrsd('CHAM_NO_S', cns)
            endif
        end do
999     continue
    end do
!
    call jedetr(vabs)
    call jedetr(vori)
    call jedetr(vcor)
    call jedetr(valmes)
!
    call jedema()
!
780 format ( a80 )
!
end subroutine
