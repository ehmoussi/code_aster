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
! aslint: disable=W1504
!
subroutine lrfmed(fileUnit    , resultName   , meshAst     , storeLast    ,&
                  fieldType   , fieldQuantity, fieldSupport, fieldNameMed_,&
                  option      , param        , prolz,&
                  storeAccess , storeCreaNb  ,&
                  storeIndxNb , storeTimeNb  ,&
                  storeIndx   , storeTime    ,&
                  storeCrit   , storeEpsi    , storePara   ,&
                  cmpNb       , cmpAstName   , cmpMedName  ,&
                  fieldStoreNb)
!
use as_med_module, only: as_med_open
implicit none
!
#include "asterf_types.h"
#include "MeshTypes_type.h"
#include "jeveux.h"
#include "asterfort/as_mficlo.h"
#include "asterfort/as_mfinvr.h"
#include "asterfort/codent.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/gnomsd.h"
#include "asterfort/idensd.h"
#include "asterfort/indiis.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lrchme.h"
#include "asterfort/lrmtyp.h"
#include "asterfort/mdchin.h"
#include "asterfort/mdexpm.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/ulisog.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
integer, intent(in) :: fileUnit, storeLast
character(len=8), intent(in) :: resultName, meshAst
character(len=16), intent(in) :: fieldType
character(len=8), intent(in) :: fieldQuantity
character(len=4), intent(in) :: fieldSupport
character(len=64), intent(in) :: fieldNameMed_
character(len=24), intent(in) :: option
character(len=8), intent(in) :: param
character(len=3), intent(in) :: prolz
character(len=10), intent(in) :: storeAccess
integer, intent(in) :: storeCreaNb, storeIndxNb, storeTimeNb
character(len=19), intent(in) :: storeIndx, storeTime
character(len=8), intent(in) :: storeCrit
real(kind=8), intent(in) :: storeEpsi
character(len=4) , intent(in):: storePara
integer, intent(in) :: cmpNb
character(len=24), intent(in) :: cmpAstName, cmpMedName
integer, intent(out) :: fieldStoreNb
!
! --------------------------------------------------------------------------------------------------
!
! MED reader
!
! Read field for several storing slots
!
! --------------------------------------------------------------------------------------------------
!
! In  fileUnit         : index of file (logical unit)
! In  resultName       : name of results datastructure
! In  storeLast        : last storing index in results datastructure
! In  meshAst          : name of (aster) mesh
! In  fieldType        : type of field (DEPL, SIEF, EPSI, ...)
! In  fieldQuantity    : physical components of field (DEPL_R, SIEF_R, ...)
! In  fieldSupport     : cell support of field (NOEU, ELNO, ELEM, ...)
! In  fieldNameMed     : name of field in MED field
! In  option           : name of finite element option to manage ELGA fiels
! In  param            : name of finite element input parameter to manage ELGA fiels
! In  prolz            : flag to have zero everywhere in field
! In  storeAccess      : how to access to the storage
! In  storeCreaNb      : number of storage slots to create
! In  storeIndxNb      : number of storage slots given by index (integer)
! In  storeIndx        : name of JEVEUX object to access storage slots given by index (integer)
! In  storeTimeNb      : number of storage slots given by time/freq (real)
! In  storeTime        : name of JEVEUX object to access storage slots given by time/freq (real)
! In  storeCrit        : type of tolerance to find time/freq (real)
! In  storeEpsi        : tolerance to find time/freq (real)
! In  storePara        : name of paremeter to access results (INST or FREQ)
! In  cmpNb            : number of components in field to get
! In  cmpAstName       : name of aster components in field to get
! In  cmpMedName       : name of MED components in field to get
! Out fieldStoreNb     : effective number of storing this field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6), parameter :: nompro ='LRFMED'
    integer :: vali(2)
    integer :: ndim, typgeo(MT_NTYMAX), letype
    integer :: nbtyp, nnotyp(MT_NTYMAX)
    integer :: renumd(MT_NTYMAX), nuanom(MT_NTYMAX, MT_NNOMAX)
    integer :: modnum(MT_NTYMAX), numnoa(MT_NTYMAX, MT_NNOMAX)
    integer :: sequenceNb, major, minor, rel
    med_idt :: fid, ifimed
    integer :: iret
    integer :: iSequence, iStore, ipas
    integer :: jvPara
    integer :: ifm, niv, jnuom
    integer :: nbma, jnbpgm, jnbpmm, ordins, jnbsmm
    character(len=8) :: nomtyp(MT_NTYMAX)
    character(len=19) :: nomch
    character(len=19) :: prefix, fieldNameAst, pchn1
    character(len=24) :: valk(2)
    character(len=24) :: nomprn
    character(len=64) :: meshMed, fieldNameMed
    character(len=200) :: fileName
    character(len=255) :: kfic
    integer :: typent, typgom
    integer, parameter :: edlect=0,ednoeu=3,edmail=0,ednoma=4,ednono=-1,typnoe=0
    character(len=1) :: saux01
    character(len=8) :: saux08
    integer :: numeStep, numeStore, inum
    integer :: iaux, itps0
    integer :: iinst
    real(kind=8) :: timeCurr
    character(len=64) :: k64b
    aster_logical :: existm, timeExist
    character(len=24), pointer :: refe(:) => null()
    integer, pointer :: vStoreIndx(:) => null()
    real(kind=8), pointer :: vStoreTime(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    nomprn  = resultName//'.PRFCN00000.PRNO'
    fieldStoreNb = 0
!
    call infmaj()
    call infniv(ifm, niv)
!
!     NOM DU FICHIER MED
    call ulisog(fileUnit, kfic, saux01)
    if (kfic(1:1) .eq. ' ') then
        call codent(fileUnit, 'G', saux08)
        fileName = 'fort.'//saux08
    else
        fileName = kfic(1:200)
    endif
!
    call as_med_open(fid, fileName, edlect, iret)
    call as_mfinvr(fid, major, minor, rel, iret)
    fieldNameMed = fieldNameMed_
    if (major .lt. 3) then
        fieldNameMed(33:64) = '                                '
    endif
    call as_mficlo(fid, iret)
!
    if (niv .gt. 1) then
        write(ifm,*) '<',nompro,'> NOM DU FICHIER MED : ',fileName
    endif
!
    prefix = '&&'//nompro//'.MED'
    call jedetr(prefix//'.NUME')
    call jedetr(prefix//'.INST')
!      CALL JEDETC('V',PREFIX,1)
!
!         RECUPERATION DU NOMBRE DE PAS DE TEMPS DANS LE CHAMP
!         ----------------------------------------------------
    ifimed = 0
    if (fieldSupport(1:2) .eq. 'NO') then
        typent = ednoeu
        typgom = typnoe
        call mdchin(fileName, ifimed, fieldNameMed, typent, typgom,&
                    prefix, sequenceNb, iret)
        if (sequenceNb .eq. 0) then
            call utmess('A', 'MED_95', sk=fieldNameMed)
            goto 240
        endif
        call jeveuo(prefix//'.INST', 'L', ipas)
        call jeveuo(prefix//'.NUME', 'L', inum)
!
    else if (fieldSupport(1:2).eq.'EL') then
        ifimed = 0
        call mdexpm(fileName, ifimed, meshMed, existm, ndim,&
                    iret)
        call lrmtyp(nbtyp, nomtyp, nnotyp, typgeo, renumd,&
                    modnum, nuanom, numnoa)
        if (fieldSupport(1:4) .eq. 'ELNO') then
            typent = ednoma
        else
            typent = edmail
        endif
!
        do letype = 1, nbtyp
            iaux = renumd(letype)
            typgom = typgeo(iaux)
            ifimed = 0
            call mdchin(fileName, ifimed, fieldNameMed, typent, typgom,&
                        prefix, sequenceNb, iret)
            if (sequenceNb .ne. 0) then
                call jeveuo(prefix//'.INST', 'L', ipas)
                call jeveuo(prefix//'.NUME', 'L', inum)
                goto 240
            endif
        end do
!
!         CAS PARTICULIER: LECTURE DU FICHIER MED DONT L'ENTITE
!         DES CHAMPS ELNO EST ENCORE 'MED_MAILLE'
        if (fieldSupport .eq. 'ELNO') then
            typent = edmail
            call utmess('A', 'MED_53', sk=fieldNameMed)
            do letype = 1, nbtyp
                iaux = renumd(letype)
                typgom = typgeo(iaux)
                ifimed = 0
                call mdchin(fileName, ifimed, fieldNameMed, typent, typgom,&
                            prefix, sequenceNb, iret)
                if (sequenceNb .ne. 0) then
                    call jeveuo(prefix//'.INST', 'L', ipas)
                    call jeveuo(prefix//'.NUME', 'L', inum)
                    goto 240
                endif
            end do
        endif
!
    endif
240 continue
!
! - Access to storage given by user
!
    iinst = 0
    if (storeAccess .eq. 'INST' .or. storeAccess .eq.'LIST_INST' .or. &
        storeAccess .eq. 'FREQ' .or. storeAccess .eq.'LIST_FREQ' ) then
        iinst = 1
    endif
    if (storeIndxNb .ne. 0) then
        call jeveuo(storeIndx//'.VALE', 'L', vi = vStoreIndx)
    endif
    if (storeTimeNb .ne. 0) then
        call jeveuo(storeTime//'.VALE', 'L', vr = vStoreTime)
    endif
    if (storeAccess .eq. 'TOUT_ORDRE') then
        fieldStoreNb = sequenceNb
    else
        fieldStoreNb = storeCreaNb
    endif
!
!         DETERMINATION DES NUMEROS D'ORDRE MED : ZI(JNUOM)
    if (storeIndxNb .ne. 0) then
        call wkvect('&&OP0150_NUMORD_MED', 'V V I', sequenceNb, jnuom)
        do iSequence = 1, sequenceNb
            if (zi(inum+2*iSequence-1) .ne. ednono) then
                zi(jnuom+iSequence-1)=zi(inum+2*iSequence-1)
            else if (zi(inum+2*(iSequence-1)).ne.ednono) then
                zi(jnuom+iSequence-1)=zi(inum+2*(iSequence-1))
            endif
        end do
    endif
!
    call dismoi('NB_MA_MAILLA', meshAst, 'MAILLAGE', repi=nbma)
    call wkvect('&&OP0150_NBPG_MAILLE', 'V V I', nbma, jnbpgm)
    call wkvect('&&OP0150_NBPG_MED', 'V V I', nbma, jnbpmm)
    call wkvect('&&OP0150_NBSP_MED', 'V V I', nbma, jnbsmm)
!
!         BOUCLE SUR LES PAS DE TEMPS
!         ---------------------------
!     CET ENTIER SERT A AVOIR LA CERTITUDE QUE LE .ORDR PRODUIT
!     EN SORTIE DE LIRE_RESU SERA STRICTEMENT CROISSANT
    ordins = storeLast
    do iStore = 1, fieldStoreNb
        fieldNameAst = '&&LRFMED.TEMPOR'
        k64b = ' '
!
        if (storeIndxNb .ne. 0) then
            numeStore = vStoreIndx(iStore)
            itps0     = indiis(zi(jnuom),numeStore,1,sequenceNb)
            if (itps0 .eq. 0) then
                call utmess('A', 'MED_87', sk=resultName, si=numeStore)
                cycle
            endif
            numeStep  = zi(inum+2*itps0-2)
        else if (storeAccess .eq. 'TOUT_ORDRE') then
            numeStore = zi(inum+2*iStore-1)
            numeStep  = zi(inum+2*iStore-2)
        else if (storeTimeNb .ne. 0) then
            timeCurr  = vStoreTime(iStore)
            timeExist = .false.
            do iSequence = 1 , sequenceNb
                if (storeCrit .eq. 'RELATIF') then
                    if (abs(zr(ipas-1+iSequence)-timeCurr) .le. abs(storeEpsi*timeCurr)) then
                        timeExist = .true.
                    endif
                else if (storeCrit .eq. 'ABSOLU') then
                    if (abs(zr(ipas-1+iSequence)-timeCurr) .le. abs(storeEpsi)) then
                        timeExist = .true.
                    endif
                endif
                if (timeExist) then
                    numeStep  = zi(inum+2*iSequence-2)
                    numeStore = zi(inum+2*iSequence-1)
                    iinst     = 0
                    exit
                endif
            end do
        endif
!
        call lrchme(fieldNameAst, fieldNameMed, k64b, meshAst, fieldSupport,&
                    fieldQuantity, typent, cmpNb, cmpAstName, cmpMedName,&
                    prolz, iinst, numeStep, numeStore, timeCurr,&
                    storeCrit, storeEpsi, fileUnit, option, param,&
                    zi(jnbpgm), zi(jnbpmm), zi(jnbsmm), iret)
!
!         POUR LES CHAM_NO : POUR ECONOMISER L'ESPACE,
!         ON ESSAYE DE PARTAGER LE PROF_CHNO DU CHAMP CREE AVEC
!         LE PROF_CHNO PRECEDENT :
        if (fieldSupport .eq. 'NOEU') then
            call dismoi('PROF_CHNO', fieldNameAst, 'CHAM_NO', repk=pchn1)
            if (.not.idensd('PROF_CHNO',nomprn(1:19),pchn1)) then
                call gnomsd(' ', nomprn, 15, 19)
                call copisd('PROF_CHNO', 'G', pchn1, nomprn)
            endif
            call jeveuo(fieldNameAst//'.REFE', 'E', vk24=refe)
            refe(2) = nomprn(1:19)
            call detrsd('PROF_CHNO', pchn1)
        endif
        if (numeStore .eq. ednono) then
            numeStore = numeStep
        endif
        if (storeTimeNb .ne. 0) then
            ordins = ordins + 1
            numeStore = ordins
        endif
!
        call rsexch(' ', resultName, fieldType, numeStore, nomch, iret)
        if (iret .eq. 100) then
        else if (iret.eq.110) then
            call rsagsd(resultName, 0)
            call rsexch(' ', resultName, fieldType, numeStore, nomch, iret)
        else
            valk (1) = resultName
            valk (2) = fieldNameAst
            vali (1) = iStore
            vali (2) = iret
            call utmess('F', 'UTILITAI8_27', nk=2, valk=valk, ni=2,vali=vali)
        endif
        call copisd('CHAMP_GD', 'G', fieldNameAst, nomch)
        call rsnoch(resultName, fieldType, numeStore)
        call rsadpa(resultName, 'E', 1, storePara, numeStore, 0, sjv=jvPara)
!
        if (storeTimeNb .ne. 0) then
            zr(jvPara) = timeCurr
        else if (storeIndxNb.ne.0) then
            zr(jvPara) = zr(ipas-1+itps0)
        else if (storeAccess .eq. 'TOUT_ORDRE') then
            zr(jvPara) = zr(ipas-1+iStore)
        endif
        call detrsd('CHAMP_GD', fieldNameAst)
    end do
    call jedetr('&&OP0150_NBPG_MAILLE')
    call jedetr('&&OP0150_NBPG_MED')
    call jedetr('&&OP0150_NBSP_MED')
    call jedetr(cmpAstName)
    call jedetr(cmpMedName)
    call jedetr('&&OP0150_NUMORD_MED')
!
    call jedema()
!
end subroutine
