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

subroutine xprls0(noma, noesom, armin, cnsln,&
                  cnslt, isozro, levset, nodtor, eletor)
!
! aslint: disable=W1501
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/conare.h"
#include "asterfort/dismoi.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
!
    character(len=2) :: levset
    character(len=8) :: noma
    character(len=19) :: cnsln, cnslt, isozro, noesom, nodtor, eletor
!
! person_in_charge: patrick.massin at edf.fr
!     ------------------------------------------------------------------
!
!       XPRLS0   : X-FEM PROPAGATION : CALCUL DES LS PROCHE DES ISO-0
!       ------     -     --                       --                -
!    DANS LE CADRE DE LA PROPAGAGTION DE FISSURE XFEM, CALCUL DES VRAIES
!     FONCTIONS DE DISTANCE SIGNEE SUR LES NOEUDS DES MAILLES COUPEES
!     PAR L'ISOZERO D'UNE LEVEL SET.
!    SI LEVSET='LN' : ON CALCULE LN & LT AU VOISINAGE DE LN=0
!    SI LEVSET='LT' : ON CALCULE LT AU VOISINAGE DE LT=0
!
!    ENTREE
!        NOMA    :   NOM DU CONCEPT MAILLAGE
!        NOESOM  :   VECTEUR LOGIQUE CONTENANT L'INFO. 'NOEUD SOMMET'
!        LCMIN   :   LONGEUR DE PLUS PETIT ARETE DU MAILLAGE NOMA
!        CNSLN   :   CHAM_NO_S LEVEL SET NORMALE
!        CNSLT   :   CHAM_NO_S LEVEL SET TANGENTE
!        LEVSET  :   ='LN' SI ON REINITIALISE LN
!                    ='LT' SI ON REINITIALISE LT
!        NODTOR  :   LISTE DES NOEUDS DEFINISSANT LE DOMAINE DE CALCUL
!        ELETOR  :   LISTE DES ELEMENTS DEFINISSANT LE DOMAINE DE CALCUL
!    SORTIE
!        CNSLN   :   CHAM_NO_S LEVEL SET NORMALE
!                    (CALCULEE SEULEMENT SI LEVSET = 'LN')
!        CNSLT   :   CHAM_NO_S LEVEL SET NORMALE CALCULEE
!        ISOZRO  :   VECTEUR LOGIQUE IDIQUANT SI LA "VRAIE" LEVEL SET
!                    (DISTANCE SIGNEE) A ETE CALCULEE
!        POIFI  :   OBJET JEVEUX REMPLI (UPWIND SEULEMENT)
!        TRIFI  :   OBJET JEVEUX REMPLI (UPWIND SEULEMENT)
!
!     ------------------------------------------------------------------
!
!
    integer :: ino, inoa, inob, ima, ifm, niv, nbnog, nbmag
    integer :: jconx2, ndim, jzero, jmaco, nbmaco, nbnoma, jmai, nunoa, nunob
    integer :: jnomco, nbnoco, nmaabs, itypma
    integer :: jnosom, nbnozo, cptzo, jlsno, jltno
    integer :: ar(12, 3), nbar, iar, na, nb 
    integer :: ndime, i
    real(kind=8) :: lsna, lsnb
    real(kind=8) :: lst(6) 
    real(kind=8) :: armin
    character(len=8) :: typma
    character(len=19) :: mai, maicou, nomcou
    real(kind=8) :: toll
!
!     DOMAIN RESTRICTION
    integer :: jnodto, jeleto, node, elem, nbno, nbma
!
    real(kind=8), pointer :: vale(:) => null()
    integer, pointer :: tmdim(:) => null()
    integer, pointer :: connex(:) => null()
!
!-----------------------------------------------------------------------
!     DEBUT
!-----------------------------------------------------------------------
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
!     EVALUATION OF THE TOLERANCE USED TO ASSESS IF THE VALUE OF THE
!     NORMAL LEVELSET IN ONE NODE IS ZERO OR NOT
!     THIS IS FIXED TO 1% OF THE LENGTH OF THE SMALLEST ELEMENT EDGE
!     IN THE MESH
    toll = 1.0d-2*armin
!
!      IF (NIV.GT.1)
    write(ifm,*)'   CALCUL DES LEVEL SETS A PROXIMITE '&
     &   //'DE L''ISOZERO DE '//levset//'.'
!
!  RECUPERATION DES CARACTERISTIQUES DU MAILLAGE
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbnog)
    call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nbmag)
!
!     RETRIEVE THE NUMBER OF THE NODES THAT MUST TO BE USED IN THE
!     CALCULUS (SAME ORDER THAN THE ONE USED IN THE CONNECTION TABLE)
    call jeveuo(nodtor, 'L', jnodto)
!
!     RETRIEVE THE TOTAL NUMBER OF THE NODES THAT MUST BE ELABORATED
    call jelira(nodtor, 'LONMAX', nbno)
!
!     RETRIEVE THE LIST OF THE ELEMENTS SUPPORTING THE NODES IN THE TORE
    call jeveuo(eletor, 'L', jeleto)
!
!     RETRIEVE THE NUMBER OF ELEMENTS DEFINING THE TORE
    call jelira(eletor, 'LONMAX', nbma)
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
    call jeveuo(noma//'.CONNEX', 'L', vi=connex)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', jconx2)
    mai = noma//'.TYPMAIL'
    call jeveuo(mai, 'L', jmai)
    call dismoi('DIM_GEOM', noma, 'MAILLAGE', repi=ndim)
    call jeveuo('&CATA.TM.TMDIM', 'L', vi=tmdim)
!
!   RECUPERATION DE L'ADRESSE DES VALEURS DES LS
    if (levset .eq. 'LN') then
        call jeveuo(cnsln//'.CNSV', 'E', jlsno)
        call jeveuo(cnslt//'.CNSV', 'E', jltno)
    else if (levset.eq.'LT') then
        call jeveuo(cnslt//'.CNSV', 'E', jlsno)
        call jeveuo(cnsln//'.CNSV', 'L', jltno)
    endif
!
!  RECUPERATION DE L'ADRESSE DE L'INFORMATION 'NOEUD SOMMET'
    call jeveuo(noesom, 'L', jnosom)
!
!  RECUPERATION DE L'ADRESSE DES VALEURS DE ISOZRO
    call jeveuo(isozro, 'E', jzero)
    do ino = 1, nbnog
        zl(jzero-1+ino)=.false.
    end do
!
! INITIALISATION DU VECTEUR LST
    do i = 1, 6
        lst(i)=0.d0
    end do
!
!
!-----------------------------------------------------------------------
!     DANS UN PREMIER TEMPS,ON S'OCCUPE DES NOEUDS SOMMETS SUR L'ISOZERO
!     ( UTILE DANS LE CAS DE MAILLES 1 OU 2 NOEUDS SONT A 0 )
!-----------------------------------------------------------------------
    nbnozo=0
    do ino = 1, nbno
        node = zi(jnodto-1+ino)
        if (abs(zr(jlsno-1+node)) .lt. toll .and. zl(jnosom-1+node)) then
            zr(jlsno-1+node)=0.d0
            zl(jzero-1+node)=.true.
            nbnozo = nbnozo+1
        endif
    end do
!
! N.B. : cette etape de reajustement des level-set assure la validite de
!        tests du type : abs(lsna) .lt. r8prem()
!
!--------------------------------------------------------------------
!     ON REPERE LES MAILLES VOLUMIQUES COUPEES OU TANGENTEES PAR LS=0
!     ( I.E. LES MAILLES OU L'ON PEUT INTERPOLER UN PLAN LS=0 )
!--------------------------------------------------------------------
!  VECTEUR CONTENANT LES NUMEROS DE MAILLES COUPEES
    maicou = '&&XPRLS0.MAICOU'
    call wkvect(maicou, 'V V I', nbmag, jmaco)
!
    nbmaco=0
    do ima = 1, nbma
!
        elem = zi(jeleto-1+ima)
!
!   VERIFICATION DU TYPE DE MAILLE
!         NDIME : DIMENSION TOPOLOGIQUE DE LA MAILLE
        ndime = tmdim(zi(jmai-1+elem))
        if (ndime .ne. ndim) goto 100
        nbnoma = zi(jconx2+elem) - zi(jconx2+elem-1)
!
!  ON COMPTE D'ABORD LE NOMBRE DE NOEUDS DE LA MAILLE QUI S'ANNULENT
        cptzo=0
        do inoa = 1, nbnoma
            nunoa=connex(zi(jconx2+elem-1)+inoa-1)
            lsna = zr(jlsno-1+nunoa)
            if (abs(lsna) .lt. toll .and. zl(jnosom-1+nunoa)) cptzo = cptzo+1
        end do
!
!  SI AU - TROIS NOEUDS S'ANNULENT (en 3D),ON A UN PLAN D'INTERSECTION
        if (cptzo .ge. ndim) then
            nbmaco = nbmaco + 1
            zi(jmaco-1+nbmaco) = elem
            goto 100
        endif
!
!  ON PARCOURT LES ARETES DE L'ELEMENT
        itypma=zi(jmai-1+elem)
        call jenuno(jexnum('&CATA.TM.NOMTM', itypma), typma)
        call conare(typma, ar, nbar)
        do iar = 1, nbar
            na=ar(iar,1)
            nb=ar(iar,2)
            nunoa=connex(zi(jconx2+elem-1)+na-1)
            nunob=connex(zi(jconx2+elem-1)+nb-1)
            lsna = zr(jlsno-1+nunoa)
            lsnb = zr(jlsno-1+nunob)
!  SI UNE ARETE EST COUPEE,LA MAILLE L'EST FORCEMENT
            if ((lsna*lsnb) .lt. 0.d0 .and. (abs(lsna).gt.r8prem()) .and.&
                (abs(lsnb).gt.r8prem())) then
                nbmaco = nbmaco + 1
                zi(jmaco-1+nbmaco) = elem
                goto 100
            endif
        end do
!
100     continue
    end do
!
!     IF EVERYTHING GOES CORRECTLY, I SHOULD FIND AT LEAST ONE ELEMENT
!     CUT BY THE ISOZERO OF LSN. IT'S BETTER TO CHECK IT BEFORE
!     CONTINUING.
    ASSERT(nbmaco.gt.0)

!-----------------------------------------------------
!     ON REPERE LES NOEUDS SOMMETS DES MAILLES COUPEES
!-----------------------------------------------------
!  VECTEUR CONTENANT LES NUMEROS DE NOEUD DES MAILLES COUPEES
    nomcou = '&&XPRLS0.NOMCOU'
    call wkvect(nomcou, 'V V I', nbmaco*6, jnomco)
!
    nbnoco=0
!  BOUCLE SUR LES NOEUDS
    do inoa = 1, nbno
        node = zi(jnodto-1+inoa)
!  ON NE CONSIDERE QUE LE NOEUDS SOMMETS
        if (zl(jnosom-1+node)) then
!  BOUCLE SUR LES MAILLES COUPEES
            do ima = 1, nbmaco
                nmaabs = zi(jmaco-1+ima)
                nbnoma = zi(jconx2+nmaabs)-zi(jconx2+nmaabs-1)
!  BOUCLE SUR LES NOEUDS DE LA MAILLE
                do inob = 1, nbnoma
                    nunob=connex(zi(jconx2+nmaabs-1)+inob-1)
                    if (nunob .eq. node) then
                        nbnoco = nbnoco+1
                        zi(jnomco-1+nbnoco) = node
                        zl(jzero-1+node)=.true.
                        goto 200
                    endif
                end do
            end do
        endif
200     continue
    end do
!
    write(ifm,*)'   NOMBRE DE NOEUD TROUVE AUTOUR DE L ISOZERO :',nbnoco+nbnozo

!   DESTRUCTION DES OBJETS VOLATILES
    call jedetr(maicou)
    call jedetr(nomcou)
!
!-----------------------------------------------------------------------
!     FIN
!-----------------------------------------------------------------------
    call jedema()
end subroutine
