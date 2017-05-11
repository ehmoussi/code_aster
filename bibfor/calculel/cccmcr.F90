subroutine cccmcr(jcesdd, numma, jrepe, jconx2, jconx1,&
                  jcoord, adcar1, adcar2, ialpha, ibeta,&
                  iepais, jalpha, jbeta, jgamma, ligrmo,&
                  ino, pgl, modeli, codret)
! ======================================================================
! COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/c3drep.h"
#include "asterfort/cesexi.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/mpglcp.h"
#include "asterfort/teattr.h"
#include "asterfort/typele.h"
!
    integer :: jcesdd, numma, jrepe, jconx2, jconx1, jcoord
    integer :: ialpha, ibeta, iepais, jalpha, adcar1(3), adcar2(3)
    integer :: jbeta, jgamma, codret, ino
    real(kind=8) :: pgl(3, 3)
    character(len=16) :: modeli
    character(len=19) :: ligrmo
!     --- ARGUMENTS ---
! ----------------------------------------------------------------------
!  CALC_CHAMP - CALCUL DE LA MATRICE DE CHANGEMENT DE REPERE
!  -    -       -            -          -             -
! ----------------------------------------------------------------------
!
!  ROUTINE SERVANT A CALCULER LA MATRICE PGL
!
! IN  :
!   BEAUCOUP DE PARAMETRES UTILES POUR EVITER DES APPELS DEJA REALISES
!   DANS L'APPELANT CCVRRL
!
! OUT :
!   PGL     R*   MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE LOCAL
!   MODELI  K16  NOM DE LA MODELISATION, CETTE INFO EST UTILE A
!                L'APPELANT
!   CODRET  I    CODE RETOUR
!     0 SI OK
!     1,2 OU 3 EN CAS DE PROBLEME
! ----------------------------------------------------------------------
! person_in_charge: nicolas.sellenet at edf.fr
    integer :: nbpt1, igrel, te, nbnol, posin, ino1, ino2, idir
    integer :: iad, inos, nuno, jcesd, jcesl, jcesv, jcesdc, jceslc
    integer :: jcesvc, iret
!
    real(kind=8) :: coordc(3, 10), alpha, beta, gamma, epais
!
    character(len=16) :: nomte, atpou, atcoq, atmod, atdis
!
    codret = 3
!
    jcesd = adcar1(1)
    jcesl = adcar1(2)
    jcesv = adcar1(3)
    jcesdc = adcar2(1)
    jceslc = adcar2(2)
    jcesvc = adcar2(3)
!
!   SI LE CHAMP A TRANSFORMER NE PORTE PAS DE COMPOSANTES SUR LA MAILLE ON DOIT LE PASSER
    nbpt1 = zi(jcesdd-1+5+4*(numma-1)+3)
    if (nbpt1 .eq. 0) goto 999
    codret = 0
!
!   RECUPERATION DE LA MODELISATION
    igrel = zi(jrepe-1+2*(numma-1)+1)
    te = typele(ligrmo,igrel)
    call jenuno(jexnum('&CATA.TE.NOMTE', te), nomte)
    call teattr('C', 'POUTRE',   atpou, iret, typel=nomte)
    call teattr('C', 'COQUE',    atcoq, iret, typel=nomte)
    call teattr('C', 'DISCRET',  atdis, iret, typel=nomte)
    call teattr('C', 'MODELI',   atmod, iret, typel=nomte)
    modeli=atmod
!
    nbnol = zi(jconx2+numma)-zi(jconx2+numma-1)
    posin = zi(jconx2+numma-1)
!
!   Suivant le type de modelisation, le changement de repere n'est pas le meme
!       poutre, barre, cable, tuyau, discret, coques
    if (atpou.eq.'OUI'.and.atmod.ne.'TU3'.and.atmod.ne.'TU6') then
        ino1 = zi(jconx1+posin-1)
        ino2 = zi(jconx1+posin)
        do idir = 1, 3
            coordc(idir,1) = zr(jcoord+3*(ino2-1)+idir-1)
            coordc(idir,2) = zr(jcoord+3*(ino1-1)+idir-1)
        enddo
!       lecture de gamma dans .carorien
        call cesexi('S', jcesd, jcesl, numma, 1, 1, jgamma, iad)
        if (iad .gt. 0) then
            gamma = zr(jcesv-1+iad)
        else
            ASSERT(.false.)
        endif
        call mpglcp('P', nbnol, coordc, alpha, beta, gamma, pgl, codret)
!
    else if (atdis.eq.'OUI') then
        if ( nbnol .eq. 1 ) then
!           lecture de alpha, beta, gamma dans .carorien
            call cesexi('S', jcesd, jcesl, numma, 1, 1, jalpha, iad)
            alpha = zr(jcesv-1+iad)
            call cesexi('S', jcesd, jcesl, numma, 1, 1, jbeta,  iad)
            beta  = zr(jcesv-1+iad)
            call cesexi('S', jcesd, jcesl, numma, 1, 1, jgamma, iad)
            gamma = zr(jcesv-1+iad)
            call mpglcp('1', nbnol, coordc, alpha, beta, gamma, pgl, codret)
        else
            ino1 = zi(jconx1+posin-1)
            ino2 = zi(jconx1+posin)
            do idir = 1, 3
                coordc(idir,1) = zr(jcoord+3*(ino2-1)+idir-1)
                coordc(idir,2) = zr(jcoord+3*(ino1-1)+idir-1)
            enddo
!           lecture de gamma dans .carorien
            call cesexi('S', jcesd, jcesl, numma, 1, 1, jgamma, iad)
            gamma = zr(jcesv-1+iad)
            call mpglcp('D', nbnol, coordc, alpha, beta, gamma, pgl, codret)
        endif
!
    else if (atmod.eq.'CQ3') then
        if (nbnol .lt. 7) then
            codret = 1
            goto 999
        endif
        inos = 0
        do ino2 = 1, nbnol
            nuno = zi(jconx1+posin+ino2-2)
            if (nuno .eq. ino) inos = ino2
            do idir = 1, 3
                coordc(idir,ino2) = zr(jcoord+3*(nuno-1)+idir-1)
            enddo
        enddo
        ASSERT(inos.ne.0)
!       RECHERCHE DE ALPHA ET BETA DANS .CARCOQUE
        call cesexi('S', jcesdc, jceslc, numma, 1, 1, ialpha, iad)
        alpha = zr(jcesvc-1+iad)
        call cesexi('S', jcesdc, jceslc, numma, 1, 1, ibeta, iad)
        beta = zr(jcesvc-1+iad)
        call cesexi('S', jcesdc, jceslc, numma, 1, 1, iepais, iad)
        epais = zr(jcesvc-1+iad)
        call c3drep(nomte, epais, alpha, beta, coordc, inos, pgl)
!
    else if (atcoq.eq.'OUI'.and.atmod.ne.'CQ3'.and.atmod.ne.'GRM'.and.&
             atmod.ne.'GRC'.and.atmod.ne.'CQA'.and.atmod.ne.'MMB') then
        do ino2 = 1, nbnol
            nuno = zi(jconx1+posin+ino2-2)
            do idir = 1, 3
                coordc(idir,ino2) = zr(jcoord+3*(nuno-1)+idir-1)
            enddo
        enddo
!       RECHERCHE DE ALPHA ET BETA DANS .CARCOQUE
        call cesexi('S', jcesdc, jceslc, numma, 1, 1, ialpha, iad)
        alpha = zr(jcesvc-1+iad)
        call cesexi('S', jcesdc, jceslc, numma, 1, 1, ibeta, iad)
        beta = zr(jcesvc-1+iad)
        call mpglcp('C', nbnol, coordc, alpha, beta, gamma, pgl, codret)
    else
        codret = 3
    endif
!
999 continue
end subroutine
