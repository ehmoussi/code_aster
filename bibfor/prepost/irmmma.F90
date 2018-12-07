! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine irmmma(fid, nomamd, nbmail, connex, point,&
                  typma, nommai, prefix, nbtyp, typgeo,&
                  nomtyp, nnotyp, renumd, nmatyp, infmed,&
                  modnum, nuanom)
! person_in_charge: nicolas.sellenet at edf.fr
!-----------------------------------------------------------------------
!     ECRITURE DU MAILLAGE -  FORMAT MED - LES MAILLES
!        -  -     -                  -         --
!-----------------------------------------------------------------------
!     ENTREE:
!       FID    : IDENTIFIANT DU FICHIER MED
!       NOMAMD : NOM DU MAILLAGE MED
!       NBMAIL : NOMBRE DE MAILLES DU MAILLAGE
!       CONNEX : CONNECTIVITES
!       POINT  : VECTEUR POINTEUR DES CONNECTIVITES (LONGUEURS CUMULEES)
!       TYPMA  : VECTEUR TYPES DES MAILLES
!       NOMMAI : VECTEUR NOMS DES MAILLES
!       PREFIX : PREFIXE POUR LES TABLEAUX DES RENUMEROTATIONS
!                A UTILISER PLUS TARD
!       NBTYP  : NOMBRE DE TYPES POSSIBLES POUR MED
!       TYPGEO : TYPE MED POUR CHAQUE MAILLE
!       NNOTYP : NOMBRE DE NOEUDS POUR CHAQUE TYPE DE MAILLES
!       NOMTYP : NOM DES TYPES POUR CHAQUE MAILLE
!       RENUMD : RENUMEROTATION DES TYPES ENTRE MED ET ASTER
!       INFMED : NIVEAU DES INFORMATIONS A IMPRIMER
!       MODNUM : INDICATEUR SI LA SPECIFICATION DE NUMEROTATION DES
!                NOEUDS DES MAILLES EST DIFFERENTES ENTRE ASTER ET MED:
!                     MODNUM = 0 : NUMEROTATION IDENTIQUE
!                     MODNUM = 1 : NUMEROTATION DIFFERENTE
!       NUANOM : TABLEAU DE CORRESPONDANCE DES NOEUDS MED/ASTER.
!                NUANOM(ITYP,J): NUMERO DANS ASTER DU J IEME NOEUD DE LA
!                MAILLE DE TYPE ITYP DANS MED.
!
!     SORTIE:
!       NMATYP : NOMBRE DE MAILLES PAR TYPE
!-----------------------------------------------------------------------
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_mmhcyw.h"
#include "asterfort/as_mmheaw.h"
#include "asterfort/as_mmhenw.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    integer :: ntymax
    parameter (ntymax = 69)
!
! 0.1. ==> ARGUMENTS
!
    integer :: fid
    integer :: nbmail, nbtyp
    integer :: connex(*), typma(*), point(*)
    integer :: typgeo(*), nnotyp(*), nmatyp(*)
    integer :: renumd(*), modnum(ntymax), nuanom(ntymax, *)
    integer :: infmed
!
    character(len=6) :: prefix
    character(len=8) :: nommai(*)
    character(len=8) :: nomtyp(*)
    character(len=*) :: nomamd
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
    character(len=6) :: nompro
    parameter ( nompro = 'IRMMMA' )
!
    integer :: edfuin
    parameter (edfuin=0)
    integer :: edmail
    parameter (edmail=0)
    integer :: ednoda
    parameter (ednoda=0)
!
    integer :: codret
    integer :: ipoin, ityp, letype
    integer :: ino
    integer :: ima
    integer :: jnomma(ntymax), jnumma(ntymax), jcnxma(ntymax)
    integer :: ifm, nivinf
!
    character(len=8) :: saux08
!====
! 1. PREALABLES
!====
!
    call jemarq()
!
    call infniv(ifm, nivinf)
!
!====
! 2. PREPARATION DES TABLEAUX PAR TYPE DE MAILLE
!====
!
! 2.1. ==> DECOMPTE DU NOMBRE DE MAILLES PAR TYPE
!          EN FAIT, ON VEUT JUSTE SAVOIR S'IL Y EN A OU PAS.
!
    do ityp = 1 , ntymax
        nmatyp(ityp) = 0
    end do
!
    do ima = 1, nbmail
        nmatyp(typma(ima)) = nmatyp(typma(ima)) + 1
    end do
!
! 2.2. ==> ON VERIFIE QUE L'ON SAIT ECRIRE LES MAILLES PRESENTES DANS
!          LE MAILLAGE
!
    do ityp = 1, ntymax
!
        if (nmatyp(ityp) .ne. 0) then
            if (typgeo(ityp) .eq. 0) then
                call utmess('F', 'PREPOST2_93', sk=nomtyp(ityp))
            endif
        endif
!
    end do
!
! 2.3. ==> CREATION DE PLUSIEURS VECTEURS PAR TYPE DE MAILLE PRESENT :
!              UN VECTEUR CONTENANT LES NOMS DES MAILLES/TYPE
!           +  UN VECTEUR CONTENANT LES NUMEROS DES MAILLES/TYPE
!           +  UN VECTEUR CONTENANT LA CONNECTIVITE DES MAILLE/TYPE
!              (CONNECTIVITE = NOEUDS + UNE VALEUR BIDON(0) SI BESOIN)
!
    do ityp = 1, ntymax
!
        if (nmatyp(ityp) .ne. 0) then
!
            call wkvect('&&'//nompro//'.NOM.'//nomtyp(ityp), 'V V K16', nmatyp(ityp), jnomma(ityp))
            call wkvect('&&'//prefix//'.NUM.'//nomtyp(ityp), 'V V I', nmatyp(ityp), jnumma(ityp))
            call wkvect('&&'//nompro//'.CNX.'//nomtyp(ityp), 'V V I', nnotyp(ityp)*nmatyp(ityp),&
                        jcnxma(ityp))
!
        endif
!
    end do
!
! 2.4. ==> ON PARCOURT TOUTES LES MAILLES. POUR CHACUNE D'ELLES, ON
!          STOCKE SON NOM, SON NUMERO, SA CONNECTIVITE
!          LA CONNECTIVITE EST FOURNIE EN STOCKANT TOUS LES NOEUDS A
!          LA SUITE POUR UNE MAILLE DONNEE.
!          C'EST CE QU'ON APPELLE LE MODE ENTRELACE DANS MED
!          A LA FIN DE CETTE PHASE, NMATYP CONTIENT LE NOMBRE DE MAILLES
!          POUR CHAQUE TYPE
!
    do ityp = 1 , ntymax
        nmatyp(ityp) = 0
    end do
!
    do ima = 1, nbmail
!
        ityp = typma(ima)
!       ON TRAITE LES PENTA18 EN OUBLIANT
!       LES NOEUDS DU CENTRE ET LES SEG4 EN OUBLIANT
!       LES 2 NOEUDS CENTRAUX:
        ipoin = point(ima)
        nmatyp(ityp) = nmatyp(ityp) + 1
!       NOM DE LA MAILLE DE TYPE ITYP DANS VECT NOM MAILLES
        zk16(jnomma(ityp)-1+nmatyp(ityp)) = nommai(ima)//'        '
!                                                         12345678
!       NUMERO ASTER DE LA MAILLE DE TYPE ITYP DANS VECT NUM MAILLES
        zi(jnumma(ityp)-1+nmatyp(ityp)) = ima
!       CONNECTIVITE DE LA MAILLE TYPE ITYP DANS VECT CNX:
!       I) POUR LES TYPES DE MAILLE DONT LA NUMEROTATION DES NOEUDS
!          ENTRE ASTER ET MED EST IDENTIQUE:
        if (modnum(ityp) .eq. 0) then
            do ino = 1, nnotyp(ityp)
                zi(jcnxma(ityp)-1+(nmatyp(ityp)-1)*nnotyp(ityp)+ino) =&
                    connex(ipoin-1+ino)
            end do
!       II) POUR LES TYPES DE MAILLE DONT LA NUMEROTATION DES NOEUDS
!          ENTRE ASTER ET MED EST DIFFERENTE (CF LRMTYP):
        else
            do ino = 1, nnotyp(ityp)
                zi(jcnxma(ityp)-1+(nmatyp(ityp)-1)*nnotyp(ityp)+ino) =&
                    connex(ipoin-1+nuanom(ityp,ino))
            end do
        endif
!
    end do
!
!====
! 3. ECRITURE
!    ON PARCOURT TOUS LES TYPES POSSIBLES POUR MED ET ON DECLENCHE LES
!    ECRITURES SI DES MAILLES DE CE TYPE SONT PRESENTES DANS LE MAILLAGE
!    LA RENUMEROTATION PERMET D'ECRIRE LES MAILLES DANS L'ORDRE
!    CROISSANT DE LEUR TYPE MED. CE N'EST PAS OBLIGATOIRE CAR ICI ON
!    FOURNIT LES TABLEAUX DE NUMEROTATION DES MAILLES. MAIS QUAND CES
!    TABLEAUX SONT ABSENTS, C'EST LA LOGIQUE QUI PREVAUT. DONC ON LA
!    GARDE DANS LA MESURE OU CE N'EST PAS PLUS CHER ET QUE C'EST CE QUI
!    EST FAIT A LA LECTURE
!====
!
    do letype = 1 , nbtyp
!
! 3.0. ==> PASSAGE DU NUMERO DE TYPE MED AU NUMERO DE TYPE ASTER
!
        ityp = renumd(letype)
!
        if (infmed .ge. 2) then
            write (ifm,3001) nomtyp(ityp), nmatyp(ityp)
        endif
    3001 format('TYPE ',a8,' : ',i10,' MAILLES')
!
        if (nmatyp(ityp) .ne. 0) then
!
! 3.1. ==> LES CONNECTIVITES
!          LA CONNECTIVITE EST FOURNIE EN STOCKANT TOUS LES NOEUDS A
!          LA SUITE POUR UNE MAILLE DONNEE.
!          C'EST CE QUE MED APPELLE LE MODE ENTRELACE
!
            call as_mmhcyw(fid, nomamd, zi(jcnxma(ityp)), nnotyp(ityp)* nmatyp(ityp), edfuin,&
                           nmatyp(ityp), edmail, typgeo(ityp), ednoda, codret)
            if (codret .ne. 0) then
                saux08='mmhcyw'
                call utmess('F', 'DVP_97', sk=saux08, si=codret)
            endif
!
! 3.2. ==> LE NOM DES MAILLES
!
            call as_mmheaw(fid, nomamd, zk16(jnomma(ityp)), nmatyp( ityp), edmail,&
                           typgeo(ityp), codret)
            if (codret .ne. 0) then
                saux08='mmheaw'
                call utmess('F', 'DVP_97', sk=saux08, si=codret)
            endif
!
! 3.3. ==> LE NUMERO DES MAILLES
!
            call as_mmhenw(fid, nomamd, zi(jnumma(ityp)), nmatyp(ityp), edmail,&
                           typgeo(ityp), codret)
            if (codret .ne. 0) then
                saux08='mmhenw'
                call utmess('F', 'DVP_97', sk=saux08, si=codret)
            endif
!
        endif
!
    end do
!
!====
! 4. LA FIN
!====
!
    do ityp = 1, ntymax
        if (nmatyp(ityp) .ne. 0) then
            call jedetr('&&'//nompro//'.NOM.'//nomtyp(ityp))
            call jedetr('&&'//nompro//'.CNX.'//nomtyp(ityp))
        endif
    end do
!
    call jedema()
!
end subroutine
