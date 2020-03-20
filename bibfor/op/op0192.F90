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

subroutine op0192()
!
use as_med_module, only: as_med_open
implicit none
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/as_mficlo.h"
#include "asterfort/as_mfinvr.h"
#include "asterfort/codent.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lrchme.h"
#include "asterfort/lrvema.h"
#include "asterfort/lrvemo.h"
#include "asterfort/ulisog.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_CHAMP
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: nompro
    parameter ( nompro = 'OP0192' )
    integer :: ednono
    parameter (ednono=-1)
    integer :: ednopt
    parameter (ednopt=-1)
    character(len=7) :: lcmpva
    parameter ( lcmpva = 'NOM_CMP' )
    character(len=11) :: lcmpvm
    parameter ( lcmpvm = 'NOM_CMP_MED' )
    integer :: iaux, jaux, iret, iinst
    med_idt :: idfimd
    integer :: fileUnit, imaj, imin, irel
    integer :: codret, iver, entityType
    integer :: numpt, numord
    integer :: cmpNb, jcmpva, jcmpvm
    integer :: nbma, jnbpgm, jnbpmm, jnbsmm
    integer :: ednoeu
    parameter (ednoeu=3)
    integer :: edmail
    parameter (edmail=0)
    integer :: ednoma
    parameter (ednoma=4)
    integer :: edlect
    parameter (edlect=0)
    real(kind=8) :: inst
    real(kind=8) :: storeEpsi
    character(len=1) :: saux01
    character(len=8) :: fieldNameAst, meshAst, nomo, fieldQuantity
    character(len=19) :: fieldNameTemp
    character(len=8) :: typech, param, storeCrit, saux08
    character(len=3) :: prolz
    character(len=4) :: fieldSupport
    character(len=16) :: nomcmd, format, fieldType
    character(len=24) :: option
    character(len=64) :: fieldNameMed, meshMed
    character(len=72) :: rep
    character(len=200) :: nofimd
    character(len=255) :: kfic
    character(len=24) :: cmpAstName, cmpMedName
    character(len=24) :: valk(2)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
!
    call infmaj()
!
!====
! 2. DETERMINATION DES OPTIONS DE LA COMMANDE :
!====
!
! 2.1. ==> FORMAT DU FICHIER
!
    call getvtx(' ', 'FORMAT', scal=format, nbret=iaux)
!
    if (format .eq. 'MED') then
        call getvtx(' ', 'NOM_MED', scal=fieldNameMed, nbret=iaux)
        if (iaux .eq. 0) then
            call utmess('F', 'MED_96')
        endif
    else
        call utmess('F', 'UTILITAI3_17', sk=format)
    endif
!
! 2.2. ==> TYPE DE CHAMP A LIRE
!
    call getvtx(' ', 'TYPE_CHAM', scal=fieldType, nbret=iaux)
    call getres(fieldNameAst, typech, nomcmd)
    fieldQuantity = fieldType(6:13)
    fieldSupport = fieldType(1:4)
    if (fieldType(1:11) .eq. 'ELGA_SIEF_R') then
        option = 'RAPH_MECA'
        param = 'PCONTPR'
    else if (fieldType(1:11).eq.'ELGA_EPSI_R') then
        option = 'EPSI_ELGA'
        param = 'PDEFOPG'
    else if (fieldType(1:11).eq.'ELGA_VARI_R') then
        option = 'RAPH_MECA'
        param = 'PVARIPR'
    else if (fieldType(1:11).eq.'ELGA_SOUR_R') then
        option = 'SOUR_ELGA'
        param = 'PSOUR_R'
    else if (fieldSupport .eq. 'ELGA') then
!        AUTRES CHAMPS ELGA : NON PREVU
        call utmess('F', 'RESULT2_95', sk=fieldType)
    else
!        CHAMPS ELNO OU AUTRES :
        option=' '
        param=' '
    endif
!
! - -  VERIFICATIONS - -
!
    if (fieldType(1:2) .eq. 'EL') then
        call getvid(' ', 'MODELE', scal=nomo, nbret=iaux)
        call lrvemo(nomo)
    endif
!
! 2.3. ==> NOM DES COMPOSANTES VOULUES
!
    cmpAstName = '&&'//nompro//'.'//lcmpva
    cmpMedName = '&&'//nompro//'.'//lcmpvm
!
    call getvtx(' ', 'NOM_CMP_IDEM', scal=rep, nbret=iaux)
!
! 2.3.1. ==> C'EST PAR IDENTITE DE NOMS
!
    if (iaux .ne. 0) then
!
        if (rep .eq. 'OUI') then
            cmpNb = 0
        else
            call utmess('F', 'UTILITAI3_18', sk=rep)
        endif
!
    else
!
! 2.3.2. ==> C'EST PAR ASSOCIATION DE LISTE
!
        call getvtx(' ', lcmpva, nbval=0, nbret=iaux)
        if (iaux .lt. 0) then
            cmpNb = -iaux
        endif
!
        call getvtx(' ', lcmpvm, nbval=0, nbret=iaux)
        if (-iaux .ne. cmpNb) then
            valk(1) = lcmpva
            valk(2) = lcmpvm
            call utmess('F', 'UTILITAI2_95', nk=2, valk=valk)
        endif
!
        if (cmpNb .gt. 0) then
            call wkvect(cmpAstName, 'V V K8', cmpNb, jcmpva)
            call getvtx(' ', lcmpva, nbval=cmpNb, vect=zk8(jcmpva), nbret=iaux)
            call wkvect(cmpMedName, 'V V K16', cmpNb, jcmpvm)
            call getvtx(' ', lcmpvm, nbval=cmpNb, vect=zk16(jcmpvm), nbret=iaux)
        endif
!
    endif
!
! 2.4a ==> PROLONGEMENT PAR ZERO OU NOT A NUMBER
!
    call getvtx(' ', 'PROL_ZERO', scal=prolz, nbret=iaux)
    if (prolz .ne. 'OUI') then
        prolz = 'NAN'
    endif
!
! 2.4b ==> UNITE LOGIQUE LIE AU FICHIER
!
    call getvis(' ', 'UNITE', scal=fileUnit, nbret=iaux)
!
! 2.5. ==> NOM DU MODELE, NOM DU MAILLAGE ASTER ASSOCIE
!
    call getvid(' ', 'MODELE', scal=nomo, nbret=iaux)
!
    call getvid(' ', 'MAILLAGE', scal=meshAst, nbret=iaux)
    if (iaux .eq. 0) then
        call dismoi('NOM_MAILLA', nomo, 'MODELE', repk=meshAst)
        if (codret .ne. 0) then
            call utmess('F', 'UTILITAI3_19')
        endif
    endif
!
! 2.6. ==> NOM DU MAILLAGE MED ASSOCIE
!
    call getvtx(' ', 'NOM_MAIL_MED', scal=meshMed, nbret=iaux)
!
    if (iaux .eq. 0) then
        meshMed = ' '
    endif
!
! 2.7. CARACTERISTIQUES TEMPORELLES
! 2.7.1. ==> NUMERO D'ORDRE EVENTUEL
!
    call getvis(' ', 'NUME_ORDRE', scal=numord, nbret=iaux)
    if (iaux .eq. 0) then
        numord = ednono
    endif
!
! 2.7.2. ==> NUMERO DE PAS DE TEMPS EVENTUEL
!
    call getvis(' ', 'NUME_PT', scal=numpt, nbret=jaux)
    if (jaux .eq. 0) then
        numpt = ednopt
    endif
!
! 2.7.3. ==> SI NI NUMERO D'ORDRE, NI NUMERO DE PAS DE TEMPS, IL Y A
!            PEUT-ETRE UNE VALEUR D'INSTANT
!
    if (iaux .eq. 0 .and. jaux .eq. 0) then
        call getvr8(' ', 'INST', scal=inst, nbret=iinst)
        if (iinst .ne. 0) then
            call getvr8(' ', 'PRECISION', scal=storeEpsi, nbret=iaux)
            call getvtx(' ', 'CRITERE', scal=storeCrit, nbret=iaux)
        endif
    else
        iinst = 0
    endif
!
!====
! 3. APPEL DE LA LECTURE AU FORMAT MED
!====
!
    if (fieldSupport .eq. 'ELGA') then
        call dismoi('NB_MA_MAILLA', meshAst, 'MAILLAGE', repi=nbma)
        call wkvect('&&OP0150_NBPG_MAILLE', 'V V I', nbma, jnbpgm)
        call wkvect('&&OP0150_NBPG_MED', 'V V I', nbma, jnbpmm)
        call wkvect('&&OP0150_NBSP_MED', 'V V I', nbma, jnbsmm)
    else
        jnbpgm=1
        jnbpmm=1
        jnbsmm=1
    endif
!
    if (format .eq. 'MED') then
!
        fieldNameTemp = '&&OP0192.TEMPOR'
        if (fieldSupport .eq. 'NOEU') then
            entityType = ednoeu
        else if (fieldSupport .eq. 'ELNO') then
!
!          DETERMINATION DU TYPE D'ENTITE CAR SELON LA VERSION MED,
!               TYPENT =4 ('MED_NOEUD_MAILLE') OU
!                      =0 ('MED_MAILLE' POUR LES VERSIONS ANTERIEURES)
!          NOM DU FICHIER MED
            call ulisog(fileUnit, kfic, saux01)
            if (kfic(1:1) .eq. ' ') then
                call codent(fileUnit, 'G', saux08)
                nofimd = 'fort.'//saux08
            else
                nofimd = kfic(1:200)
            endif
            call as_med_open(idfimd, nofimd, edlect, iret)
            call as_mfinvr(idfimd, imaj, imin, irel, iret)
            call as_mficlo(idfimd, iret)
!          ON VERIFIE LA VERSION DU FICHIER A LA VERSION 2.3.3
            entityType=ednoma
            iver= imaj*100 + imin*10 + irel
            if (iver .lt. 233) then
                entityType=edmail
                call utmess('A', 'MED_53', sk=fieldNameMed)
            else
                entityType=ednoma
            endif
        else
            entityType=edmail
        endif
!
        call lrvema(meshAst, fileUnit, fieldNameMed)
!
        call lrchme(fieldNameTemp, fieldNameMed, meshMed, meshAst, fieldSupport,&
                    fieldQuantity, entityType, cmpNb, cmpAstName, cmpMedName,&
                    prolz, iinst, numpt, numord, inst,&
                    storeCrit, storeEpsi, fileUnit, option, param,&
                    zi(jnbpgm), zi(jnbpmm), zi(jnbsmm), codret)
!
        call copisd('CHAMP_GD', 'G', fieldNameTemp, fieldNameAst)
        if (fieldSupport(1:2) .eq. 'NO') then
            call detrsd('CHAM_NO', fieldNameTemp)
        else
            call detrsd('CHAM_ELEM', fieldNameTemp)
        endif
!
    endif
!
    call jedema()
!
end subroutine
