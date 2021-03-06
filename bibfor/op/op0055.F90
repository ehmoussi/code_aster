! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine op0055()
    implicit none
!
!      OPERATEUR :     DEFI_FOND_FISS
!
!-----------------------------------------------------------------------
!
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/cncinv.h"
#include "asterfort/fonbas.h"
#include "asterfort/fonfis.h"
#include "asterfort/fonimp.h"
#include "asterfort/foninf.h"
#include "asterfort/fonlev.h"
#include "asterfort/fonmai.h"
#include "asterfort/fonnoe.h"
#include "asterfort/fonnof.h"
#include "asterfort/fonvec.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    integer :: iadr1, ifm, niv
    integer :: nbocc, nbnoff
    integer :: ibas, ibid, iocc, idon, idonn, ifonoe, ndonn
    integer :: iret1, iret, irets
    integer :: n1, n2
    character(len=6) :: nompro
    character(len=8) :: resu, noma, typfon, confin
    character(len=9) :: entit(8)
    character(len=13) :: motcl(8)
    character(len=16) :: typres, oper
    character(len=19) :: basfon, basloc, cnxinv, fontyp, lnno, ltno
    character(len=24) :: valk(2), entnom, fondfi, fonoeu
! DEB-------------------------------------------------------------------
!
    call jemarq()
    nompro = 'OP0055'
!
    call infniv(ifm, niv)
!
! ---  RECUPERATION DES ARGUMENTS DE LA COMMANDE
!
    call getres(resu, typres, oper)
!
! ---  RECUPERATIONS RELATIVES AU MAILLAGE
!      -----------------------------------
!
    call getvid(' ', 'MAILLAGE', scal=noma, nbret=nbocc)
!
! ---  RECUPERATION DE LA CONNECTIVITE INVERSE
!
    cnxinv='&&'//nompro//'.CNXINV'
    call cncinv(noma, [ibid], 0, 'V', cnxinv)
!
!
!     ---------------------------------------------------------------
!     RECUPERATION DU TYPE DE FOND : OUVERT OU FERME
!     ---------------------------------------------------------------
!
    call getfac('FOND_FISS', nbocc)
    do 1 iocc = 1, nbocc
!
        call getvtx('FOND_FISS', 'TYPE_FOND', iocc=iocc, nbval=0, nbret=n1)
        if (n1 .ne. 0) then
            call getvtx('FOND_FISS', 'TYPE_FOND', iocc=iocc, scal=typfon, nbret=n1)
        else
            typfon = 'OUVERT'
        endif
!
!       DANS LE CAS D'UN FOND FERME, ON INTERDIT LES MCS NOEUD ET GROUP_NO
        if (typfon.eq.'FERME') then
            call getvtx('FOND_FISS', 'GROUP_NO', iocc=iocc, nbval=0, nbret=n1)
            if (n1 .ne. 0) then
                call utmess('F', 'RUPTURE0_98')
            endif
        endif
!
!     ---------------------------------------------------------------
!     VERIFICATION DE L'EXISTANCE DES ENTITES DU MAILLAGE RENSEIGNEES
!     ET CONSTRUCTION DE VECTEURS DE TRAVAIL POUR CHACUNE D'ELLES
!     ---------------------------------------------------------------
!
        entit(1) = '.GROUPENO'
        entit(2) = '.GROUPEMA'
        entit(3) = '.NOMNOE'
        entit(4) = '.GROUPENO'
        motcl(1) = 'GROUP_NO'
        motcl(2) = 'GROUP_MA'
        motcl(3) = 'NOEUD_ORIG'
        motcl(4) = 'GROUP_NO_ORIG'
        if (typfon .eq. 'OUVERT') then
            entit(5) = '.NOMNOE'
            entit(6) = '.GROUPENO'
            motcl(5) = 'NOEUD_EXTR'
            motcl(6) = 'GROUP_NO_EXTR'
            ndonn = 6
        else if (typfon.eq.'FERME') then
            entit(5) = '.NOMMAI'
            entit(6) = '.GROUPEMA'
            motcl(5) = 'MAILLE_ORIG'
            motcl(6) = 'GROUP_MA_ORIG'
            ndonn = 6
        else
            ASSERT(.FALSE.)
        endif
        do 11 idonn = 1, ndonn
            call getvtx('FOND_FISS', motcl(idonn), iocc=iocc, nbval=0, nbret=n1)
            n1 = -n1
            if (n1 .gt. 0) then
                call wkvect('&&'//nompro//'.'//motcl(idonn), 'V V K24', n1, iadr1)
                call getvtx('FOND_FISS', motcl(idonn), iocc=iocc, nbval=n1, vect=zk24(iadr1),&
                            nbret=n2)
                do 111 idon = 1, n1
                    entnom = zk24(iadr1-1 + idon)
                    call jenonu(jexnom(noma//entit(idonn), entnom), ibid)
                    if (ibid .eq. 0) then
                        valk(1) = entnom
                        valk(2) = motcl(idonn)
                        call utmess('F', 'RUPTURE0_7', nk=2, valk=valk)
                    endif
111              continue
            endif
11      continue
!
!
!
!       ---------------------------------------------------------------
!       CONSTRUCTION DE FOND DE FISSURE
!       ---------------------------------------------------------------
!
!        SI LE MOT CLE FACTEUR EST GROUP_NO
!        ----------------------------------------
!
        call jeexin('&&'//nompro//'.GROUP_NO', iret1)
        if (iret1.ne.0) then
            call jeveuo(noma//'.DIME', 'L', iret1)
!!          LE MOT-CLE GROUP_NO EST UNIQUEMENT AUTORISE EN DIMENSION 2
            if (zi(iret1-1+6).eq.2) then
                call fonnoe(resu, noma, cnxinv, nompro, nbnoff)
            else
                call utmess('F', 'RUPTURE1_9')
            endif
        endif
!
!        SI LE MOT CLE FACTEUR EST GROUP_MA
!        ----------------------------------------
!
        call jeexin('&&'//nompro//'.GROUP_MA', iret1)
        if (iret1.ne.0) then
            call jeveuo(noma//'.DIME', 'L', iret1)
!!          LE MOT-CLE GROUP_MA EST UNIQUEMENT AUTORISE EN DIMENSION 3
            if (zi(iret1-1+6).eq.3) then
                call fonmai(resu, noma, typfon, iocc, nbnoff)
            else
                call utmess('F', 'RUPTURE1_8')
            endif
        endif
!C
!
!       DESTRUCTION DES VECTEURS DE TRAVAIL
!       ----------------------------------------
        do 20 idonn = 1, ndonn
            call jeexin('&&'//nompro//'.'//motcl(idonn), iret)
            if (iret .ne. 0) call jedetr('&&'//nompro//'.'//motcl(idonn))
20      continue
!
 1  continue
!
!
!     ---------------------------------------------------------------
!     VERIFICATION DES DONNEES SUR LES LEVRES ET LES VECTEURS
!     ---------------------------------------------------------------
!
!
!     TRAITEMENT DES LEVRES: LEVRE_SUP ET LEVRE_INF
!     ----------------------------------------
!
    call fonlev(resu, noma, nbnoff)
!
!
!     TRAITEMENT DE LA NORMALE ET DES
!     MOTS CLES FACTEUR : DTAN_EXTR, DTAN_ORIG
!                         VECT_GRNO_ORIG, VECT_GRNO_EXTR
!     ----------------------------------------
!
    call fonvec(resu, noma, cnxinv)
!
    call jedetr(cnxinv)
!
!     ---------------------------------------------------------------
!     CREATION DU VECTEUR .FONDFISS CONTENANT LES COORDONNEES ET LES
!     ABSCISSES CURVILIGNES DES NOEUDS DU FOND
!     ---------------------------------------------------------------
!
!     VECTEUR CONTENANT LES NOMS DES NOEUDS DU FOND DE FISSURE
!     ----------------------------------------
    call jeexin(resu//'.FOND.NOEU', iret)
    if (iret .ne. 0) then
        fonoeu = resu//'.FOND.NOEU'
        call jeveuo(fonoeu, 'L', ifonoe)
        if (typfon .eq. 'FERME') then
            ASSERT(zk8(ifonoe+1-1).eq.zk8(ifonoe+nbnoff-1))
        endif
    else
        ASSERT(.FALSE.)
    endif
!
    fondfi = resu//'.FONDFISS'
    call fonfis(noma, nbnoff, fonoeu, fondfi)
!
!     ---------------------------------------------------------------
!     CREATION DE LA BASE LOCALE ET DES LEVEL SETS EN CHAQUE NOEUD
!     ---------------------------------------------------------------
!
!     LA BASE LOCALE ET DES LEVEL SETS SONT CALCULEES EN CHAQUE NOEUD
!     QUE SI L'OBJET .BASEFOND EXISTE DEJA
    call jeexin(resu//'.BASEFOND', ibas)
    if (ibas .ne. 0) then
        basfon = resu//'.BASEFOND'
        if (nbnoff .ne. 1) then
            fontyp = resu//'.FOND.TYPE'
        endif
        basloc = resu//'.BASLOC'
        lnno = resu//'.LNNO'
        ltno = resu//'.LTNO'
        call fonbas(noma, basfon, fontyp, fondfi, nbnoff,&
                    basloc, lnno, ltno)
    endif
!
!
!     ---------------------------------------------------------------
!     EXTRACTION DES NOEUDS DES LEVRES SUR DIRECTON NORMALE
!     ---------------------------------------------------------------
!
    call getvtx(' ', 'CONFIG_INIT', scal=confin, nbret=ibid)
    if (confin .eq. 'COLLEE') then
        call jeexin(resu//'.LEVRESUP.MAIL', irets)
        if (irets .ne. 0) then
            call fonnof(resu, noma, typfon, nbnoff)
        endif
    endif
!
!     ---------------------------------------------------------------
!     STOCKAGE D'INFOS UTILES DANS LA SD EN SORTIE
!     ---------------------------------------------------------------
!
    call foninf(resu, typfon)
!
!     ---------------------------------------------------------------
!     IMPRESSIONS SI INFO=2
!     ---------------------------------------------------------------
!
    if (niv .eq. 2) then
        call fonimp(resu)
    endif
!
    call jedema()
end subroutine
