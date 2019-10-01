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
!
subroutine charci(chcine, mfact, mo, valeType)
!
use HHO_Dirichlet_module, only : hhoGetKinematicValues
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getmjm.h"
#include "asterfort/gettco.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/chcsur.h"
#include "asterfort/cnocns.h"
#include "asterfort/cnscre.h"
#include "asterfort/cnsred.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/imprsd.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/reliem.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/rs_getfirst.h"
#include "asterfort/getKinematicValues.h"
!
    character(len=*) :: chcine, mfact, mo
    character(len=1) :: valeType
! OBJET :
!        TRAITEMENT DES MOTS CLES FACTEURS DE L'OPERATEUR
!        CREATION D'UN CHAM_NO_S CONTENANT LES DEGRES IMPOSES
!
!-----------------------------------------------------------------------
! VAR  CHCINE  K*19    : NOM DE LA CHARGE CINEMATIQUE
! IN   MFACT   K*16    : MOT CLE FACTEUR A TRAITER
!                        MOTS CLES ADMIS : MECA_IMPO
!                                          THER_IMPO
!                                          ACOU_IMPO
! IN   MO      K*      : NOM DU MODELE
! IN   TYPE    K*1     : 'R','C' OU 'F' TYPE DES MOTS CLES
    integer :: ifm, niv, icmp, cmp, ier, ino, userNodeNb, nuno
    integer :: ioc, jcnsv, jcnsl, idino, userDOFNb
    integer :: idnddl, idvddl, nbddl, iddl, i, idprol
    integer :: nbcmp, jcmp, noc, n1, iret
    integer :: jnoxfl, nlicmp, icmpmx, nume_first
    integer, parameter :: mxcmp=100
    character(len=8) :: k8b, mesh, nomgd, nogdsi, gdcns, answer
    character(len=8) :: evoim, licmp(20), chcity(mxcmp)
    character(len=16), parameter :: motcle(5) = (/ 'GROUP_MA', 'MAILLE  ',&
                                                   'GROUP_NO', 'NOEUD   ',&
                                                   'TOUT    '/)
    character(len=16) :: keywordFact, phenom, typco, userDOFName(mxcmp)
    character(len=19) :: chci, cns, cns2, depla, noxfem
    character(len=24) :: userNodeName, cnuddl, cvlddl, nprol
    character(len=80) :: titre
    aster_logical :: lxfem, l_hho
    character(len=8), pointer :: afck(:) => null()
    data nprol/'                   .PROL'/
! --- DEBUT -----------------------------------------------------------
!
    call jemarq()
    call infniv(ifm, niv)
!
    chci = chcine
    call jeveuo(chci//'.AFCK', 'E', vk8=afck)
    keywordFact = mfact
    call getfac(keywordFact, noc)
!
    call dismoi('NOM_MAILLA', mo, 'MODELE', repk=mesh)
    call dismoi('PHENOMENE', mo, 'MODELE', repk=phenom)
    call dismoi('NOM_GD', phenom, 'PHENOMENE', repk=nomgd)
    call dismoi('NOM_GD_SI', nomgd, 'GRANDEUR', repk=nogdsi)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', nogdsi), 'L', jcmp)
    call jelira(jexnom('&CATA.GD.NOMCMP', nogdsi), 'LONMAX', nbcmp)
    cns='&&CHARCI.CNS'
!
!    --------------------------------------------------------
!    MODELE X-FEM
!    --------------------------------------------------------
    call jeexin(mo(1:8)//'.XFEM_CONT', ier)
    if (ier .eq. 0) then
        lxfem = .false.
    else
        lxfem = .true.
        noxfem = '&&CHARCI.NOXFEM'
        call cnocns(mo(1:8)//'.NOXFEM', 'V', noxfem)
        call jeveuo(noxfem//'.CNSL', 'L', jnoxfl)
    endif
!
    call dismoi('EXI_HHO', mo, 'MODELE', repk=answer)
    l_hho = answer .eq. 'OUI'

!
!     -- CAS DE EVOL_IMPO : ON IMPOSE TOUS LES DDLS DU 1ER CHAMP
!     ------------------------------------------------------------
    evoim=' '
    if (noc .eq. 0) then
        ASSERT(keywordFact.eq.'MECA_IMPO'.or.keywordFact.eq.'THER_IMPO')
        call getvid(' ', 'EVOL_IMPO', scal=evoim, nbret=n1)
        ASSERT(n1.eq.1)
        call getvtx(' ', 'NOM_CMP', nbval=20, vect=licmp, nbret=nlicmp)
        ASSERT(nlicmp.ge.0)
!
        call gettco(evoim, typco)
        if (typco .eq. 'EVOL_THER') then
            afck(1)='CITH_FT'
        else if (typco.eq.'EVOL_ELAS'.or.typco.eq.'EVOL_NOLI') then
            afck(1)='CIME_FT'
        else
            ASSERT(.false.)
        endif
        afck(3)=evoim
!
!       -- C'EST LE CHAMP DU 1ER NUMERO D'ORDRE QUI IMPOSE SA LOI:
        call rs_getfirst(evoim, nume_first)
        if (keywordFact .eq. 'MECA_IMPO') then
            call rsexch('F', evoim, 'DEPL', nume_first, depla,&
                        iret)
        else
            call rsexch('F', evoim, 'TEMP', nume_first, depla,&
                        iret)
        endif
        call cnocns(depla, 'V', cns)
!
!       -- SI NOM_CMP EST UTILISE, IL FAUT "REDUIRE" CNS :
        if (nlicmp .gt. 0) then
            cns2='&&CHARCI.CNS2'
            call cnsred(cns, 0, [0], nlicmp, licmp,&
                        'V', cns2)
            call detrsd('CHAM_NO_S', cns)
            call copisd('CHAM_NO_S', 'V', cns2, cns)
            call detrsd('CHAM_NO_S', cns2)
        endif
        goto 200
    endif
!
!
!
! --- NOM DE TABLEAUX DE TRAVAIL :
    userNodeName = '&&CHARCI.INO'
    ASSERT((valeType.eq.'F').or.(valeType.eq.'R').or.(valeType.eq.'C'))
!
    if (valeType .eq. 'F') then
        gdcns = nomgd
        gdcns(5:6) = '_F'
    else if (valeType.eq.'R') then
        gdcns = nomgd
    else if (valeType.eq.'C') then
        gdcns = nomgd
    endif
!
!
! --- CREATION D'UN CHAM_NO_S
!     POUR LIMITER LA TAILLE DU CHAM_NO_S,
!     ON DETERMINE LE PLUS GRAND NUMERO DE CMP ELIMINEE
!     ---------------------------------------------------------
    icmpmx=0
    do ioc = 1, noc
        call getmjm(keywordFact, ioc, mxcmp, userDOFName, chcity,&
                    userDOFNb)
        ASSERT(userDOFNb.gt.0)
        do iddl = 1, userDOFNb
            icmp = indik8( zk8(jcmp), userDOFName(iddl)(1:8), 1, nbcmp )
            icmpmx=max(icmpmx,icmp)
        end do
    end do
    ASSERT(icmpmx.gt.0)
    if (l_hho) then
        icmpmx = nbcmp
    endif
    call cnscre(mesh, gdcns, icmpmx, zk8(jcmp), 'V',&
                cns)
!
!
! --- REMPLISSAGE DU CHAM_NO_S
    call jeveuo(cns//'.CNSV', 'E', jcnsv)
    call jeveuo(cns//'.CNSL', 'E', jcnsl)
!
    do ioc = 1, noc
!
! ----- NOEUDS A CONTRAINDRE :
        call reliem(' ', mesh, 'NU_NOEUD', keywordFact, ioc,&
                    5, motcle, motcle, userNodeName, userNodeNb)
        if (userNodeNb .eq. 0) goto 100
        call jeveuo(userNodeName, 'L', idino)
!
! ----- DDL A CONTRAINDRE :
        call getmjm(keywordFact, ioc, mxcmp, userDOFName, chcity,&
                    userDOFNb)
! ----- Get kinematic values
        if (l_hho) then
            call hhoGetKinematicValues(keywordFact, ioc         ,&
                                       mo         , nogdsi     , valeType    ,&
                                       userDOFNb  , userDOFName ,&
                                       cnuddl     , cvlddl      , nbddl)
        else
            call getKinematicValues(keywordFact , ioc         ,&
                                    mesh        , nogdsi      , valeType,&
                                    lxfem       , noxfem      ,&
                                    userDOFNb   , userDOFName ,&
                                    userNodeNb  , userNodeName,&
                                    cnuddl      , cvlddl      , nbddl)
        endif
        call jeveuo(cnuddl, 'L', idnddl)
        call jeveuo(cvlddl, 'L', idvddl)
!
! --- on recherche si, quand on a des fonct. il y en a une = f(temps)
!
        if (valeType .eq. 'F') then
            do i = 1, nbddl
                nprol(1:8) = zk8(idvddl-1+i)
                call jeveuo(nprol, 'L', idprol)
                if (zk24(idprol+2) .eq. 'INST') then
                    afck(1)(5:7) = '_FT'
                    goto 122
                else if (( zk24(idprol).eq.'NAPPE').and. ( zk24(idprol+6).eq.'INST')) then
                    afck(1)(5:7) = '_FT'
                    goto 122
                endif
            end do
        endif
122     continue
!
! ----- affectation dans le cham_no_s
        if (valeType .eq. 'R') then
            do cmp = 1, nbddl
                k8b = zk8(idnddl-1+cmp)
                icmp = indik8( zk8(jcmp), k8b, 1, nbcmp )
                do ino = 1, userNodeNb
                    nuno = zi(idino-1+ino)
                    zr(jcnsv+(nuno-1)*icmpmx+icmp-1) = zr(idvddl-1+ cmp)
                    zl(jcnsl+(nuno-1)*icmpmx+icmp-1) = .true.
                end do
            end do
        else if (valeType .eq. 'C') then
            do cmp = 1, nbddl
                k8b = zk8(idnddl-1+cmp)
                icmp = indik8( zk8(jcmp), k8b, 1, nbcmp )
                do ino = 1, userNodeNb
                    nuno = zi(idino-1+ino)
                    zc(jcnsv+(nuno-1)*icmpmx+icmp-1) = zc(idvddl-1+ cmp)
                    zl(jcnsl+(nuno-1)*icmpmx+icmp-1) = .true.
                end do
            end do
        else if (valeType .eq. 'F') then
            do cmp = 1, nbddl
                k8b = zk8(idnddl-1+cmp)
                icmp = indik8( zk8(jcmp), k8b, 1, nbcmp )
                do ino = 1, userNodeNb
                    nuno = zi(idino-1+ino)
                    zk8(jcnsv+(nuno-1)*icmpmx+icmp-1) = zk8(idvddl-1+ cmp)
                    zl(jcnsl+(nuno-1)*icmpmx+icmp-1) = .true.
                end do
            end do
        endif
!
        call jedetr(userNodeName)
        call jedetr(cnuddl)
        call jedetr(cvlddl)
!
100     continue
    end do
200 continue
!
!
    if (( niv.ge.2) .and. (evoim.eq.' ')) then
        titre = '******* IMPRESSION DU CHAMP DES DDL IMPOSES *******'
        call imprsd('CHAMP_S', cns, ifm, titre)
    endif
!
!
!   -- creation de la sd affe_char_cine
    call chcsur(chci, cns, valeType, mo, nogdsi)
    call detrsd('CHAMP', cns)
!
!   -- si evol_impo : il ne faut pas utiliser les valeurs de chci :
    if (evoim .ne. ' ') call jedetr(chci//'.AFCV')
!
    if (lxfem) then
        call jedetr(noxfem)
    endif
!
    call jedema()
end subroutine
