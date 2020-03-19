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
subroutine lridea(fileUnit   ,&
                  resultName , resultType ,&
                  model      , meshAst    ,&
                  fieldNb    , fieldList  ,&
                  storeAccess,&
                  storeIndxNb, storeTimeNb,&
                  storeIndx  , storeTime  ,&
                  storeCrit  , storeEpsi  ,&
                  storePara)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/getvis.h"
#include "asterfort/assert.h"
#include "asterfort/cescre.h"
#include "asterfort/cesexi.h"
#include "asterfort/cnscre.h"
#include "asterfort/codent.h"
#include "asterfort/crsdfi.h"
#include "asterfort/decod1.h"
#include "asterfort/decod2.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/gnomsd.h"
#include "asterfort/iradhs.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/numeok.h"
#include "asterfort/rsutc2.h"
#include "asterfort/stock.h"
#include "asterfort/utmess.h"
#include "asterfort/ulisop.h"
#include "asterfort/ulopen.h"
!
integer, intent(in) :: fileUnit
character(len=8), intent(in) :: resultName
character(len=16), intent(in) :: resultType
character(len=8), intent(in) :: model, meshAst
integer, intent(in) :: fieldNb
character(len=16), intent(in) :: fieldList(100)
character(len=10), intent(in) :: storeAccess
integer, intent(in) :: storeIndxNb, storeTimeNb
character(len=19), intent(in) :: storeIndx, storeTime
real(kind=8), intent(in) :: storeEpsi
character(len=8), intent(in) :: storeCrit
character(len=4), intent(in) :: storePara
!
! --------------------------------------------------------------------------------------------------
!
! IDEAS reader
!
! Read field
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
! In  storePara        : name of paremeter to access results (INST or FREQ)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: zero
    character(len=24) :: noojb
    real(kind=8) :: rbid, val(1000), fileTime, masgen, amrge
    integer :: vali, nbval, iaux, ichamp
    integer :: jcnsv, jcnsl, jcesd, jcesl
    integer :: nbrec, numdat, numch, iast, isup, itype
    integer :: inoide, inoast, cellNume, ielide, knoide, knoast
    integer :: nbcmp, nbcmid, ich, icmp, nbcmp1, maxnod, lon1, versio
    integer :: irec, valatt, ifield, fileIndx, ibid, ilu1
    integer :: i, iexp, nbnoe, nbfiel, nbnoeu, nbelem
    integer :: iret, idecal, icmp1, icmp2, inatur, kk, numode
    integer :: nbvari, nvar
    aster_logical :: trouve, astock, chamok, zcmplx, ldepl
    character(len=4) :: tychas, tychid
    character(len=6) :: kar
    character(len=8) :: nomgd, licmp(1000), nomno, cellName
    character(len=8) :: nomnoa, nomnob, prolo
    character(len=13) :: a13bid
    character(len=14) :: numeDof
    character(len=16) :: fieldType, noidea, fieldTypeSave, datasetType, fileName
    character(len=19) :: chs, prchnd, prchn2, prchn3, ligrel
    character(len=80) :: rec(20)
    character(len=16), pointer :: fid_nom(:) => null()
    character(len=8), pointer :: fid_cmp(:) => null()
    real(kind=8), pointer :: cesv(:) => null()
    integer, pointer :: cnsd(:) => null()
    integer, pointer :: typmail(:) => null()
    integer, pointer :: fid_loc(:) => null()
    integer, pointer :: fid_par(:) => null()
    integer, pointer :: permuta(:) => null()
    integer, pointer :: fid_nbc(:) => null()
    integer, pointer :: fid_num(:) => null()
!
    parameter (nbfiel=40,versio=5)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    zero = 0.d0
    fieldTypeSave=' '
!
    zcmplx = .false.
    ligrel = model//'.MODELE'
!
! - Open file
!
    fileName = ' '
    if (ulisop(fileUnit, fileName) .eq. 0) then
        call ulopen(fileUnit, ' ', ' ', 'NEW', 'O')
    endif
!
! - Number of internal state variable
!
    call getvis(' ', 'NB_VARI', scal=nbvari, nbret=nvar)
!
! - Access to mesh
!
    call dismoi('NB_MA_MAILLA', meshAst, 'MAILLAGE', repi=nbelem)
    call dismoi('NB_NO_MAILLA', meshAst, 'MAILLAGE', repi=nbnoeu)
    call jeveuo(meshAst//'.TYPMAIL', 'L', vi=typmail)
!
!- TABLEAU DE PERMUTATION POUR LES CONNECTIVITES DES MAILLES :
    call iradhs(versio)
    call jeveuo('&&IRADHS.PERMUTA', 'L', vi=permuta)
    call jelira('&&IRADHS.PERMUTA', 'LONMAX', lon1)
    maxnod=permuta(lon1)
!
!- CREATION DE LA STRUCTURE DE DONNEES FORMAT_IDEAS ---
!
    noidea = '&&LIRE_RESU_IDEA'
    call crsdfi(fieldList, fieldNb, noidea)
!
!- OUVERTURE EN LECTURE DES OBJETS COMPOSANTS LA SD FORMAT_IDEAS
!
    call jeveuo(noidea//'.FID_NOM', 'L', vk16=fid_nom)
    call jeveuo(noidea//'.FID_NUM', 'L', vi=fid_num)
    call jeveuo(noidea//'.FID_PAR', 'L', vi=fid_par)
    call jeveuo(noidea//'.FID_LOC', 'L', vi=fid_loc)
    call jeveuo(noidea//'.FID_CMP', 'L', vk8=fid_cmp)
    call jeveuo(noidea//'.FID_NBC', 'L', vi=fid_nbc)
!
! - Get profile for numbering nodal fields
!
    prchnd = ' '
    if (resultType(1:9) .eq. 'MODE_MECA') then
        call dismoi('NUME_DDL', resultName, 'RESU_DYNA', repk=numeDof)
        if (numeDof .ne. ' ') then
            prchnd = numeDof(1:14)//'.NUME'
        endif
    endif
    rewind fileUnit
!
!- LECTURE DU NUMERO DU DATASET
!
 10 continue
    read (fileUnit,'(A6)',end=170,err=160) kar
!
!- ON NE LIT QUE LES DATASETS 55, 57 ET 2414
!
    if (kar .eq. '    55') then
        nbrec = 8
        numdat = 55
    else if (kar.eq.'    57') then
        nbrec = 8
        numdat = 57
    else if (kar.eq.'  2414') then
        nbrec = 13
        numdat = 2414
    else
        goto 10
    endif
!
!-LECTURE DE L'ENTETE DU DATASET
!
    do irec = 1, nbrec
        read (fileUnit,'(A80)',end=160) rec(irec)
    end do
!
!-TRAITEMENT DE L'ENTETE : ON RECHERCHE SI LE CONTENU EST
! CONFORME A CELUI PRESENT DANS LA SD FORMAT_IDEAS
!
    do ich = 1, fieldNb
        if (fid_num(ich) .eq. numdat) goto 40
    end do
    goto 10
!
 40 continue
!
! RECUPERATION DU NOMCHA DU DATASET
    if ((numdat .eq. 55) .or. (numdat .eq. 57)) then
        irec = 6
    else if (numdat .eq. 2414) then
        irec = 9
    else
        goto 10
    endif
!
    ifield = 4
    call decod2(rec, irec, ifield, 0, ichamp,&
                rbid, trouve)
!
    chamok = ASTER_FALSE
    do ich = 1, fieldNb
        if (.not.chamok) then
            valatt = fid_par((ich-1)*800+(irec-1)*40+4)
            if (valatt .eq. 9999) then
                if (ichamp .eq. 0) datasetType='VARI_ELNO'
                if (ichamp .eq. 2) datasetType='SIEF_ELNO'
                if (ichamp .eq. 3) datasetType='EPSA_ELNO'
                if (ichamp .eq. 5) datasetType='TEMP'
                if (ichamp .eq. 8) datasetType='DEPL'
                if (ichamp .eq. 11) datasetType='VITE'
                if (ichamp .eq. 12) datasetType='ACCE'
                if (ichamp .eq. 15) datasetType='PRES'
                if (datasetType(1:3) .eq. fid_nom(ich)(1:3)) then
                    fieldType = fid_nom(ich)
                    numch = ich
                    chamok = ASTER_TRUE
                endif
            else
                do irec = 1, nbrec
                    do ifield = 1, nbfiel
                        valatt = fid_par((ich-1)*800+ (irec-1)* 40+ifield)
                        if (valatt .ne. 9999) then
                            call decod1(rec, irec, ifield, valatt, trouve)
                            if (.not.trouve) goto 70
                        endif
                    end do
                end do
                chamok = ASTER_TRUE
                fieldType = fieldList(ich)
                numch = ich
            endif
        endif
 70     continue
    end do
    if (.not.chamok) goto 10
!
!- TRAITEMENT DU NUMERO D'ORDRE, DE L'INSTANT OU DE LA FREQUENCE
    irec = fid_loc((numch-1)*12+1)
    ifield = fid_loc((numch-1)*12+2)
    call decod2(rec, irec, ifield, 0, fileIndx,&
                rbid, trouve)
    if (.not.trouve) then
        call utmess('F', 'PREPOST3_31')
    endif
!
    if (storeAccess .eq. 'INST' .or. storeAccess .eq. 'LIST_INST' .or. storePara .eq. 'INST') then
        irec = fid_loc((numch-1)*12+3)
        ifield = fid_loc((numch-1)*12+4)
        call decod2(rec, irec, ifield, 1, ibid,&
                    fileTime, trouve)
        if (.not.trouve) then
            call utmess('F', 'PREPOST3_32')
        endif
    endif
!
    if (storeAccess .eq. 'FREQ' .or. storeAccess .eq. 'LIST_FREQ' .or. storePara .eq. 'FREQ') then
        irec = fid_loc((numch-1)*12+5)
        ifield = fid_loc((numch-1)*12+6)
        call decod2(rec, irec, ifield, 1, ibid,&
                    fileTime, trouve)
        if (.not.trouve) then
            call utmess('F', 'PREPOST3_33')
        endif
    endif
!---  ON RECUPERE NUME_MODE ET MASS_GENE S'ILS SONT PRESENTS:
    numode=0
    masgen=0.d0
    amrge=0.d0
!---  NUME_MODE :
    irec = fid_loc((numch-1)*12+7)
    ifield = fid_loc((numch-1)*12+8)
    call decod2(rec, irec, ifield, 0, numode,&
                rbid, trouve)
!---  MASS_GENE :
    irec = fid_loc((numch-1)*12+9)
    ifield = fid_loc((numch-1)*12+10)
    call decod2(rec, irec, ifield, 1, ibid,&
                masgen, trouve)
!---  AMOR_GENE :
    irec = fid_loc((numch-1)*12+11)
    ifield = fid_loc((numch-1)*12+12)
    call decod2(rec, irec, ifield, 2, ibid,&
                amrge, trouve)
!
! - Check if field from file is in the selection list
!
    call numeok(storeAccess,&
                storeIndxNb, storeTimeNb,&
                storeIndx  , storeTime  ,&
                storeCrit  , storeEpsi  ,&
                fileIndx   , fileTime   ,&
                astock)
!
!- ON RECHERCHE LE TYPE DE CHAMP
!
    if (numdat .eq. 55) then
        tychid = 'NOEU'
    else if (numdat.eq.57) then
        tychid = 'ELNO'
    else if (numdat.eq.2414) then
        irec = 3
        ifield = 1
        call decod2(rec, irec, ifield, 0, ilu1,&
                    rbid, trouve)
        if (.not.trouve) then
            call utmess('F', 'PREPOST3_34')
        endif
        if (ilu1 .eq. 1) then
            tychid = 'NOEU'
        else if (ilu1.eq.2) then
            tychid = 'ELGA'
        else if (ilu1.eq.3) then
            tychid = 'ELNO'
        endif
    endif
!
!- RECHERCHE DU NOMBRE DE COMPOSANTES CONTENUES DANS LE DATASET
!
    if (numdat .eq. 55 .or. numdat .eq. 57) then
        irec = 6
        ifield = 6
    else if (numdat.eq.2414) then
        irec = 9
        ifield = 6
    endif
    call decod2(rec, irec, ifield, 0, nbcmid,&
                rbid, trouve)
    if (.not.trouve) then
        call utmess('F', 'PREPOST3_35')
    endif
!
!- ON RECHERCHE DANS LE FICHIER UNV SI LA NATURE DU CHAMP
!  DE DEPLACEMENT
!  'DEPL_R' -> REEL     --> INATUR = 2,4 -> REEL
!  'DEPL_C' -> COMPLEXE --> INATUR = 5,6-> COMPLEXE
!
    ifield = 5
    call decod2(rec, irec, ifield, 0, inatur,&
                rbid, trouve)
    if (.not.trouve) then
        call utmess('F', 'PREPOST3_36')
    endif
    if (inatur .eq. 5 .or. inatur .eq. 6) zcmplx = .true.
!
!- ON RECHERCHE LE TYPE DE CHAMP DEMANDE PAR L'UTILISATEUR
!  ET LA GRANDEUR ASSOCIEE
!
    call rsutc2(resultType, fieldType, nomgd, tychas)
!
!- VERIFICATION DE LA COMPATIBILITE DU CHAMP DEMANDE
!  AVEC LE CHAMP IDEAS
    if (tychid .ne. tychas) then
        call utmess('F', 'PREPOST3_37')
    endif
!
!- VERIFICATION SI LE CHAMP IDEAS ET ASTER SONT DE MEME NATURE
!  REEL OU COMPLEXE
!
    if (.not.zcmplx) then
        if (resultType .eq. 'DYNA_HARM' .or. resultType .eq. 'HARM_GENE' .or. resultType .eq.&
            'MODE_MECA_C') then
            call utmess('F', 'PREPOST3_38')
        endif
    endif
!
    if (astock) then
!
!- CREATION DES CHAMPS SIMPLES NOEUDS ET ELEMENTS
!
        nbcmp = fid_nbc(numch)
!
        nbcmp1 = 0
        do icmp = 1, nbcmp
            if (fid_cmp((numch-1)*1000+icmp) .ne. 'XXX') then
                nbcmp1 = nbcmp1 + 1
                licmp(nbcmp1) = fid_cmp((numch-1)*1000+icmp)
            endif
        end do
!
        if (tychid .eq. 'NOEU') then
!
            chs = '&&LRIDEA.CHNS'
            call cnscre(meshAst, nomgd, nbcmp1, licmp, 'V',&
                        chs)
        else
!
            call jeexin(ligrel//'.LGRF', iret)
            if (iret .eq. 0) then
                call utmess('F', 'PREPOST3_39')
            endif
            chs = '&&LRIDEA.CHES'
!
            if (fieldType(1:4) .eq. 'VARI') nbcmp1 = nbvari
!
            call cescre('V', chs, tychas, meshAst, nomgd,&
                        nbcmp1, licmp, [ibid], [-1], [-nbcmp1])
        endif
!
! --- LECTURE DU CHAMP NOEUDS
!
        if (tychid .eq. 'NOEU') then
            call jeveuo(chs//'.CNSD', 'E', vi=cnsd)
            call jeveuo(chs//'.CNSV', 'E', jcnsv)
            call jeveuo(chs//'.CNSL', 'E', jcnsl)
!
            call getvtx(' ', 'PROL_ZERO', scal=prolo, nbret=iret)
            if (prolo(1:3) .eq. 'OUI') then
                call utmess('I', 'PREPOST_13', sk=fieldType)
                call jelira(chs//'.CNSV', 'LONMAX', nbval)
                if (zcmplx) then
                    do iaux = 1, nbval
                        zc(jcnsv-1+iaux) = dcmplx(0.d0,0.d0)
                        zl(jcnsl-1+iaux) = .true.
                    end do
                else
                    do iaux = 1, nbval
                        zr(jcnsv-1+iaux) = 0.d0
                        zl(jcnsl-1+iaux) = .true.
                    end do
                endif
            endif
!
 90         continue
!
            read (fileUnit,'(I10,A13,A8)',end=160) inoide,a13bid,nomnoa
            if (inoide .eq. -1) goto 150
!
            nomno='NXXXXXXX'
            call codent(inoide, 'G', nomno(2:8))
            call jenonu(jexnom(meshAst//'.NOMNOE', nomno), inoast)
!  ON ESSAIE DE RECUPERER LE NUMERO DU NOEUD DIRECTEMENT
!  SI ON NE LE TROUVE PAS VIA NXXXX
            if (inoast .eq. 0) then
                call jenuno(jexnum(meshAst//'.NOMNOE', inoide), nomnob)
                if (nomnob .ne. nomnoa) then
                    call utmess('F', 'PREPOST3_40')
                endif
                inoast=inoide
            endif
            ASSERT(inoast.gt.0)
!
!
            if (inoast .gt. nbnoeu) then
                vali = inoast
                call utmess('F', 'PREPOST5_45', si=vali)
            endif
!
            idecal = (inoast-1)*cnsd(2)
            if (zcmplx) then
                read (fileUnit,'(6E13.5)',end=160) (val(i),i=1,2*nbcmid)
                icmp1 = 0
                do icmp = 1, nbcmp
                    icmp2 = icmp*2
                    if (fid_cmp((numch-1)*1000+icmp) .ne. 'XXX') then
                        icmp1 = icmp1 + 1
                        zc(jcnsv-1+idecal+icmp1) = dcmplx( val(icmp2-1) , val(icmp2))
                        zl(jcnsl-1+idecal+icmp1) = .true.
                    endif
                end do
            else
                read (fileUnit,'(6E13.5)',end=160) (val(i),i=1,nbcmid)
                icmp1 = 0
                do icmp = 1, nbcmp
                    if (fid_cmp((numch-1)*1000+icmp) .ne. 'XXX') then
                        icmp1 = icmp1 + 1
                        zr(jcnsv-1+idecal+icmp1) = val(icmp)
                        zl(jcnsl-1+idecal+icmp1) = .true.
                    endif
                end do
            endif
            goto 90
! - LECTURE DU CHAMP ELEMENT
!
        else if (tychid.eq.'ELNO') then
            call jeveuo(chs//'.CESD', 'L', jcesd)
            call jeveuo(chs//'.CESV', 'E', vr=cesv)
            call jeveuo(chs//'.CESL', 'E', jcesl)
!
120         continue
            read (fileUnit,'(4I10)',end=160) ielide,iexp,nbnoe,nbcmid
            if (fieldType(1:4) .eq. 'VARI') nbcmp = nbvari
            if (ielide .eq. -1) goto 150
            cellName='MXXXXXXX'
            call codent(ielide, 'G', cellName(2:8))
            call jenonu(jexnom(meshAst//'.NOMMAI', cellName), cellNume)
!  ON ESSAIE DE RECUPERER LE NUMERO DE LA MAILLE DIRECTEMENT
!  SI ON NE LE TROUVE PAS VIA MXXXX
            if (cellNume .eq. 0) cellNume = ielide
            ASSERT(cellNume.gt.0)
!
            if (cellNume .gt. nbelem) then
                vali = cellNume
                call utmess('F', 'PREPOST5_46', si=vali)
            endif
            itype=typmail(cellNume)
!
            do knoide = 1, nbnoe
!
!           -- CALCUL DE KNOAST :
                do iast = 1, nbnoe
                    isup=permuta(maxnod*(itype-1)+iast)
                    if (isup .eq. knoide) goto 142
                end do
                call utmess('F', 'PREPOST3_40')
142             continue
                knoast=iast
!
                read (fileUnit,'(6E13.5)',end=160) (val(i),i=1,nbcmid)
                icmp1 = 0
                do icmp = 1, nbcmp
                    if (fid_cmp((numch-1)*1000+icmp) .ne. 'XXX') then
                        icmp1 = icmp1 + 1
                        call cesexi('S', jcesd, jcesl, cellNume, knoast,&
                                    1, icmp1, kk)
                        cesv(abs(kk)) = val(icmp)
                        zl(jcesl-1+abs(kk)) = .true.
                    endif
                end do
            end do
!
            goto 120
        else if (tychid.eq.'ELGA') then
            call utmess('F', 'PREPOST3_41')
        endif
!
150     continue
! ----- Get profile of numbering
        ldepl=(fieldType.eq.'DEPL'.or.fieldType.eq.'VITE'.or.fieldType.eq.'ACCE')
        if (prchnd .eq. ' ' .or. (.not.ldepl)) then
            if (fieldType .eq. fieldTypeSave) then
                prchn3=prchn2
            else
                noojb='12345678.00000.NUME.PRNO'
                call gnomsd(' ', noojb, 10, 14)
                prchn3=noojb(1:19)
            endif
            fieldTypeSave = fieldType
            prchn2=prchn3
        else
            prchn3=prchnd
        endif
! ----- Get current
        call stock(resultName, chs, fieldType, ligrel, tychas,&
                   fileIndx, fileTime, numode, masgen, amrge,&
                   prchn3)
        goto 10
    else
        goto 10
    endif
!
    goto 180
160 continue
    call utmess('F', 'ALGORITH5_5')
!
170 continue
!
180 continue
    call jedetr('&&IRADHS.PERMUTA')
    call jedetr('&&IRADHS.CODEGRA')
    call jedetr('&&IRADHS.CODEPHY')
    call jedetr('&&IRADHS.CODEPHD')
    call jedema()
end subroutine
