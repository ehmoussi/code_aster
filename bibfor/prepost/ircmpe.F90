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

subroutine ircmpe(nofimd, ncmpve, numcmp, exicmp, nbvato,&
                  nbmaec, limaec, adsd, adsl, nbimpr,&
                  ncaimi, ncaimk, tyefma, typmai, typgeo,&
                  nomtyp, typech, profas, promed, prorec,&
                  nroimp, chanom, sdcarm)
! aslint: disable=W1504
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/celfpg.h"
#include "asterfort/cesexi.h"
#include "asterfort/infniv.h"
#include "asterfort/ircael.h"
#include "asterfort/ircmpf.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    integer :: nbvato, ncmpve, numcmp(ncmpve), nbmaec, typmai(*), adsd
    integer :: limaec(*), nbimpr, typgeo(*), profas(nbvato), tyefma(*)
    integer :: nroimp(nbvato), promed(nbvato), prorec(nbvato), adsl
    character(len=*) :: nofimd
    character(len=8) :: nomtyp(*), typech, sdcarm
    character(len=19) :: chanom
    character(len=24) :: ncaimi, ncaimk
    aster_logical :: exicmp(nbvato)
! person_in_charge: nicolas.sellenet at edf.fr
!_______________________________________________________________________
!     ECRITURE D'UN CHAMP - MAILLES ET PROFIL SUR LES ELEMENTS
!        -  -       -       -          -              -
!_______________________________________________________________________
!     ENTREES :
!       NOFIMD : NOM DU FICHIER MED
!       NCMPVE : NOMBRE DE COMPOSANTES VALIDES EN ECRITURE
!       NUMCMP : NUMEROS DES COMPOSANTES VALIDES
!       EXICMP : EXISTENCE DES COMPOSANTES PAR MAILLES
!       NBVATO : NOMBRE DE VALEURS TOTALES
!       NBMAEC : NOMBRE D'ENTITES A ECRIRE (O, SI TOUTES)
!       LIMAEC : LISTE DES ENTITES A ECRIRE SI EXTRAIT
!       ADSK, D, ... : ADRESSES DES TABLEAUX DES CHAMPS SIMPLIFIES
!       TYPMAI : TYPE ASTER POUR CHAQUE MAILLE
!       TYEFMA : NRO D'ELEMENT FINI OU DE MAILLE ASSOCIE A CHAQUE MAILLE
!       TYPGEO : TYPE GEOMETRIQUE DE MAILLE ASSOCIEE AU TYPE ASTER
!       NOMTYP : NOM DES TYPES DE MAILLES ASTER
!       PROREC : PROFIL RECIPROQUE. AUXILIAIRE.
!     SORTIES :
!       NBIMPR : NOMBRE D'IMPRESSIONS
!       NCAIMI : STRUCTURE ASSOCIEE AU TABLEAU CAIMPI
!         CAIMPI : ENTIERS POUR CHAQUE IMPRESSION
!                  CAIMPI(1,I) = TYPE D'EF / MAILLE ASTER (0, SI NOEUD)
!                  CAIMPI(2,I) = NOMBRE DE POINTS (GAUSS OU NOEUDS)
!                  CAIMPI(3,I) = NOMBRE DE SOUS-POINTS
!                  CAIMPI(4,I) = NOMBRE DE COUCHES
!                  CAIMPI(5,I) = NOMBRE DE SECTEURS
!                  CAIMPI(6,I) = NOMBRE DE FIBTRES
!                  CAIMPI(7,I) = NOMBRE DE MAILLES A ECRIRE
!                  CAIMPI(8,I) = TYPE DE MAILLES ASTER (0, SI NOEUD)
!                  CAIMPI(9,I) = TYPE GEOMETRIQUE AU SENS MED
!                  CAIMPI(10,I) = NOMBRE TOTAL DE MAILLES IDENTIQUES
!       NCAIMK : STRUCTURE ASSOCIEE AU TABLEAU CAIMPK
!         CAIMPK : CARACTERES POUR CHAQUE IMPRESSION
!                  CAIMPK(1,I) = NOM DE LA LOCALISATION ASSOCIEE
!                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
!                  CAIMPK(3,I) = NOM DE L'ELEMENT DE STRUCTURE
!       PROFAS : PROFIL ASTER. C'EST LA LISTE DES NUMEROS ASTER DES
!                ELEMENTS POUR LESQUELS LE CHAMP EST DEFINI
!       PROMED : PROFIL MED. C'EST LA LISTE DES NUMEROS MED DES
!                ELEMENTS POUR LESQUELS LE CHAMP EST DEFINI
!       NROIMP : NUMERO DE L'IMPRESSION ASSOCIEE A CHAQUE MAILLE
!_______________________________________________________________________
!
#include "jeveux.h"
    character(len=80) :: ednopf, ednoga
    parameter (ednopf=' ')
    parameter (ednoga=' ')
!
    integer :: ntymax, nmaxfi
    parameter (ntymax=69)
    parameter (nmaxfi=10)
    integer :: ifm, nivinf, ibid, iret, iaux, jaux, kaux, ima, jcesd, laux
    integer :: jcesc, jcesl, jcesv, nrefma
    integer :: nrcmp, nrpg, nrsp, nbpg, nbsp, nval, typmas, nbimp0, nrimpr
    integer :: nmaty0(ntymax), adraux(ntymax), nbtcou, nbqcou, nbsec, nbfib
    integer :: adcaii, adcaik, nbgrf, nugrfi(nmaxfi)
    integer :: nbgrf2, nbtcou2, nbqcou2, nbsec2, nbfib2, ima2
    integer :: nugrf2(nmaxfi), igrfi, imafib
!
    character(len=16) :: nomfpg
    character(len=64) :: noprof
!
    aster_logical :: exicar, grfidt, elga_sp, okgrcq, oktuy
    character(len=16), pointer :: tabnofpg(:) => null()
    character(len=16), pointer :: nofpgma(:) => null()
!
!====
! 1. PREALABLES
!====
    call infniv(ifm, nivinf)
!
    if (nivinf .gt. 1) write (ifm,805) 'DEBUT DE IRCMPE'
!
!====
! 2. ON REMPLIT UN PREMIER TABLEAU PAR MAILLE :
!    . VRAI DES QU'UNE DES COMPOSANTES DU CHAMP EST PRESENTE SUR
!      LA MAILLE
!    . FAUX SINON
!    REMARQUE : ON EXAMINE LES NCMPVE COMPOSANTES QUI SONT DEMANDEES,
!    MAIS IL FAUT BIEN TENIR COMPTE DE LA NUMEROTATION DE REFERENCE
!====
    laux = adsd + 1
    do iaux = 1 , nbvato
        laux = laux + 4
        nbpg = zi(laux)
        nbsp = zi(laux+1)
        do nrcmp = 1 , ncmpve
            kaux = numcmp(nrcmp)
            do nrpg = 1 , nbpg
                do nrsp = 1 , nbsp
                    call cesexi('C', adsd, adsl, iaux, nrpg,&
                                nrsp, kaux, jaux)
                    if (jaux .gt. 0) then
                        exicmp(iaux) = .true.
                        goto 21
                    endif
                enddo
            enddo
        enddo
21  enddo
!
!====
! 3. PROFAS : LISTE DES MAILLES POUR LESQUELS ON AURA IMPRESSION
!    UNE MAILLE EST PRESENTE SI ET SEULEMENT SI AU MOINS UNE COMPOSANTE
!    Y EST DEFINIE ET SI ELLE FAIT PARTIE DU FILTRAGE DEMANDE
!====
    nval = 0
!
! 3.1. ==> SANS FILTRAGE : C'EST LA LISTE DES MAILLES QUI POSSEDENT
!          UNE COMPOSANTE VALIDE
    if (nbmaec .eq. 0) then
        do iaux = 1 , nbvato
            if (exicmp(iaux)) then
                nval = nval + 1
                profas(nval) = iaux
            endif
        enddo
!
! 3.2. ==> AVEC FILTRAGE : C'EST LA LISTE DES MAILLES REQUISES ET AVEC
!          UNE COMPOSANTE VALIDE
    else
        do jaux = 1 , nbmaec
            iaux = limaec(jaux)
            if (exicmp(iaux)) then
                nval = nval + 1
                profas(nval) = iaux
            endif
        enddo
    endif
!
!====
! 4. CARACTERISATIONS DES IMPRESSIONS
!    ON TRIE SELON DEUX CRITERES :
!    1. LE NOMBRE DE SOUS-POINTS
!    2. LE TYPE D'ELEMENT FINI POUR UN CHAMP ELGA, OU LE TYPE DE LA
!       MAILLE, POUR UN AUTRE TYPE DE CHAMP. LE TABLEAU TYEFMA VAUT DONC
!       EFMAI OU TYPMAI A L'APPEL , SELON LE TYPE DE CHAMP.
!====
! 4.1. ==> TABLEAU DES CARACTERISATIONS ENTIERES DES IMPRESSIONS
!          ALLOCATION INITIALE
    nbimp0 = 20
    iaux = 10*nbimp0
    call wkvect(ncaimi, 'V V I', iaux, adcaii)
!
! 4.2. ==> PARCOURS DES MAILLES QUI PASSENT LE FILTRE
    nbimpr = 0
!     SI ON EST SUR UN CHAMP ELGA, LE TRI DOIT SE FAIRE SUR LES FAMILLES
!     DE POINTS DE GAUSS
    if (typech(1:4) .eq. 'ELGA') then
        call celfpg(chanom, '&&IRCMPE.NOFPGMA', ibid)
        AS_ALLOCATE(vk16=tabnofpg, size=nval)
        call jeveuo('&&IRCMPE.NOFPGMA', 'L', vk16=nofpgma)
    endif
!
    call jeexin(sdcarm//'.CANBSP    .CESV', iret)
    exicar=.false.
    if (iret .ne. 0 .and. typech(1:4) .eq. 'ELGA') then
        call jeveuo(sdcarm//'.CANBSP    .CESD', 'L', jcesd)
        call jeveuo(sdcarm//'.CANBSP    .CESC', 'L', jcesc)
        call jeveuo(sdcarm//'.CANBSP    .CESL', 'L', jcesl)
        call jeveuo(sdcarm//'.CANBSP    .CESV', 'L', jcesv)
        exicar=.true.
    endif
!
    do iaux = 1 , nval
        ima = profas(iaux)
        nrefma = tyefma(ima)
        !
        laux = adsd + 4*ima + 1
        nbpg = zi(laux)
        nbsp = zi(laux+1)
        nomfpg = 'a fac'
        elga_sp = .false.
        if (typech(1:4) .eq. 'ELGA') then
            nomfpg = nofpgma(ima)
            if ( exicar ) then
                elga_sp = .true.
            endif
        endif
        imafib = 0
        !
        if ( (nbsp.ge.1) .and. elga_sp ) then
            call ircael(jcesd, jcesl, jcesv, jcesc, ima,&
                        nbqcou, nbtcou, nbsec, nbfib, nbgrf, nugrfi)
            if (nbfib .ne. 0) imafib = ima
        endif
        !
        ! 4.2.1. ==> RECHERCHE D'UNE IMPRESSION SEMBLABLE
        do jaux = 1 , nbimpr
            if (typech(1:4) .eq. 'ELGA') then
                ! Pour les ELGA, tri sur les familles de points de gauss
                if (.not.exicar) then
                    ! si on n'a pas de cara_elem, le cas est simple
                    ! on compare le nom de la famille de pg et nbsp
                    if (tabnofpg(jaux).eq.nomfpg .and. &
                        zi(adcaii+10*(jaux-1)+2).eq.nbsp) then
                        nrimpr = jaux
                        goto 423
                    endif
                else
                    if (tabnofpg(jaux) .eq. nomfpg) then
                        ! Les différents cas : PMF, Coques, Tuyaux, Grille
                        if (nbfib .ne. 0) then
                            ! Pour les PMF, on compare aussi les groupes de fibres
                            ima2 = zi(adcaii+10*(jaux-1)+5)
                            call ircael(jcesd, jcesl, jcesv, jcesc, ima2,&
                                        nbqcou2, nbtcou2, nbsec2, nbfib2, nbgrf2, nugrf2)
                            if ((nbfib2.eq.nbfib).and.(nbgrf2.eq.nbgrf)) then
                                grfidt = .true.
                                do igrfi = 1, nbgrf2
                                    if (nugrf2(igrfi).ne.nugrfi(igrfi)) grfidt = .false.
                                enddo
                                if (grfidt) then
                                    nrimpr = jaux
                                    goto 423
                                endif
                            endif
                        else
                            ! Coque ou grille
                            okgrcq = (nbqcou.ge.1).and.(nbsp.ge.1)
                            ! tuyau
                            oktuy  = (nbtcou.ge.1).and.(nbsec.ge.1)
                            !
                            kaux = adcaii+10*(jaux-1)
                            if (oktuy.and.(zi(kaux+3).eq.nbtcou).and. &
                                          (zi(kaux+4).eq.nbsec)) then
                                ! Tuyaux : même nb de couche et de secteur ==> même nbsp
                                nrimpr = jaux
                                goto 423
                            else if (okgrcq.and.(zi(kaux+3).eq.nbqcou).and. &
                                                (zi(kaux+2).eq.nbsp)) then
                                ! Coques ou Grilles : même nb de couche et de sous-point
                                !   Coques  nbsp = 3*nbqcou
                                !   Grilles nbqcou=nbsp=1
                                nrimpr = jaux
                                goto 423
                            endif
                        endif
                    endif
                endif
            else
                if (zi(adcaii+10*(jaux-1)).eq.nrefma .and. &
                    zi(adcaii+10*(jaux-1)+2).eq.nbsp) then
                    nrimpr = jaux
                    goto 423
                endif
            endif
        enddo
        !
        ! 4.2.2. ==> ON CREE UNE NOUVELLE IMPRESSION SI ON DEPASSE LA LONGUEUR RESERVEE, ON DOUBLE
        if (nbimpr .eq. nbimp0) then
            nbimp0 = 2*nbimp0
            call juveca(ncaimi, 10*nbimp0)
            call jeveuo(ncaimi, 'E', adcaii)
        endif
        !
        nbimpr = nbimpr + 1
        jaux = adcaii+10*(nbimpr-1)
        ! CAIMPI(1,I) = TYPE D'EF / MAILLE ASTER (0, SI NOEUD)
        zi(jaux) = nrefma
        ! CAIMPI(2,I) = NOMBRE DE POINTS (DE GAUSS OU NOEUDS)
        zi(jaux+1) = nbpg
        ! CAIMPI(3,I) = NOMBRE DE SOUS-POINTS
        zi(jaux+2) = nbsp
        ! CAIMPI(4,I) = NOMBRE DE COUCHES  : Tuyaux ou Coques-Grilles
        ! CAIMPI(5,I) = NOMBRE DE SECTEURS : Tuyaux
        if ( elga_sp ) then
            if ( imafib .eq. 0) then
                ! Tuyaux
                if ((nbsec.ge.1).and.(nbtcou.ge.1)) then
                    zi(jaux+3) = nbtcou
                    zi(jaux+4) = nbsec
                ! Coques
                else if ((nbqcou.ge.1).and.(nbsp.eq.3*nbqcou)) then
                    zi(jaux+3) = nbqcou
                    zi(jaux+4) = 0
                ! Grilles
                else if ((nbqcou.eq.1).and.(nbsp.eq.1)) then
                    zi(jaux+3) = nbqcou
                    zi(jaux+4) = 0
                else
                    ! Ce n'est pas un élément à sous-point
                    zi(jaux+3) = 0
                    zi(jaux+4) = 0
                endif
            else
                zi(jaux+3) = 0
                zi(jaux+4) = 0
            endif
        else
            zi(jaux+3) = 0
            zi(jaux+4) = 0
        endif
        ! CAIMPI(6,I) = NUMERO DE LA MAILLE 'EXEMPLE' POUR LES PMF
        zi(jaux+5) = imafib
        ! CAIMPI(7,I) = NOMBRE DE MAILLES A ECRIRE
        zi(jaux+6) = 0
        ! CAIMPI(8,I) = TYPE DE MAILLES ASTER (0, SI NOEUD)
        zi(jaux+7) = typmai(ima)
        ! CAIMPI(9,I) = TYPE GEOMETRIQUE AU SENS MED
        zi(jaux+8) = typgeo(typmai(ima))
        !
        if (typech(1:4) .eq. 'ELGA') then
            tabnofpg(nbimpr) = nomfpg
        endif
        nrimpr = nbimpr
        !
        ! 4.2.3. ==> MEMORISATION DE L'IMPRESSION DE CETTE MAILLE
        !            CUMUL DU NOMBRE DE MAILLES POUR CETTE IMPRESSION
423     continue
        !
        nroimp(ima) = nrimpr
        jaux = adcaii+10*(nrimpr-1)+6
        zi(jaux) = zi(jaux) + 1
    enddo
    !
    if (typech(1:4) .eq. 'ELGA') then
        AS_DEALLOCATE(vk16=tabnofpg)
        call jedetr('&&IRCMPE.NOFPGMA')
    endif
    if ( nbimpr.eq.0 ) then
        goto 999
    endif
!
!====
! 5. CONVERSION DU PROFIL EN NUMEROTATION MED
!    PROMED : ON STOCKE LES VALEURS DES NUMEROS DES MAILLES AU SENS MED PAR TYPE DE MAILLES.
!    IL FAUT REORDONNER LE TABLEAU PROFAS PAR IMPRESSION SUCCESSIVE :
!    LE TABLEAU EST ORGANISE EN SOUS-TABLEAU CORRESPONDANT A CHAQUE
!    IMPRESSION. ON REPERE CHAQUE DEBUT DE SOUS-TABLEAU AVEC ADRAUX.
!====
! 5.1. ==> PROREC : C'EST LA LISTE RECIPROQUE. POUR LA MAILLE NUMERO
!                   IAUX EN NUMEROTATION ASTER, ON A SA POSITION DANS LE
!                   TABLEAU DES VALEURS S'IL FAIT PARTIE DE LA LISTE
!                   ET 0 SINON.
    do iaux = 1 , nval
        ima = profas(iaux)
        prorec(ima) = iaux
    enddo
!
! 5.2. ==> ADRESSES DANS LE TABLEAU PROFAS
!          ADRAUX(IAUX) = ADRESSE DE LA FIN DE LA ZONE DE L'IMPRESSION
!                         PRECEDENTE, IAUX-1
    adraux(1) = 0
    do iaux = 2 , nbimpr
        adraux(iaux) = adraux(iaux-1) + zi(adcaii+10*(iaux-2)+6)
    enddo
!
! 5.3. ==> DECOMPTE DU NOMBRE DE MAILLES PAR TYPE DE MAILLES ASTER
!          NMATY0(IAUX) = NUMERO MED DE LA MAILLE COURANTE, DANS LA
!                         CATEGORIE ASTER IAUX. A LA FIN, NMATY0(IAUX)
!                         VAUT LE NOMBRE DE MAILLES PAR TYPE DE MAILLES
!                         ASTER, POUR TOUTES LES MAILLES DU MAILLAGE
!          ADRAUX(JAUX) = ADRESSE DANS LES TABLEAUX PROMED ET PROFAS
!                         DE LA MAILLE COURANTE ASSOCIEE A L'IMPRESSION
!                         NUMERO JAUX
    do iaux = 1 , ntymax
        nmaty0(iaux) = 0
    enddo
!
    do ima = 1 , nbvato
!
        typmas = typmai(ima)
        nmaty0(typmas) = nmaty0(typmas) + 1
        if (prorec(ima) .ne. 0) then
            jaux = nroimp(ima)
            adraux(jaux) = adraux(jaux) + 1
            promed(adraux(jaux)) = nmaty0(typmas)
            profas(adraux(jaux)) = ima
        endif
!
    enddo
!
!====
! 6. MEMORISATION DANS LES CARACTERISTIQUES DE L'IMPRESSION
!====
! 6.1. ==> NOMBRE DE MAILLES DU MEME TYPE
    do iaux = 1 , nbimpr
!
        jaux = adcaii+10*(iaux-1)
        typmas = zi(jaux+7)
!                  CAIMPI(10,I) = NOMBRE DE MAILLES IDENTIQUES
        zi(jaux+9) = nmaty0(typmas)
!
    enddo
!
! 6.2. ==> CARACTERISTIQUES CARACTERES
    iaux = 3*nbimpr
    call wkvect(ncaimk, 'V V K80', iaux, adcaik)
    do iaux = 1 , nbimpr
        jaux = adcaik+2*(iaux-1)
!                  CAIMPK(1,I) = NOM DE LA LOCALISATION ASSOCIEE
        zk80(jaux) = ednoga
!                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
        zk80(jaux+1) = ednopf
!                  CAIMPK(3,I) = NOM DE L'ELEMENT DE STRUCTURE
        zk80(jaux+2) = ednopf
    enddo
!
!====
! 7. STOCKAGE DES EVENTUELS PROFILS DANS LE FICHIER MED
!====
    kaux = 1
!
    do iaux = 1 , nbimpr
!
        jaux = adcaii+10*(iaux-1)
!
!       SI LE NOMBRE DE MAILLES A ECRIRE EST >0
        if (zi(jaux+6) .gt. 0) then
!
!         SI LE NOMBRE DE MAILLES A ECRIRE EST DIFFERENT
!         DU NOMBRE TOTAL DE MAILLES DE MEME TYPE:
            if (zi(jaux+6) .ne. zi(jaux+9)) then
                call ircmpf(nofimd, zi(jaux+6), promed(kaux), noprof)
!
!                  CAIMPK(2,I) = NOM DU PROFIL AU SENS MED
                zk80(adcaik+3*(iaux-1)+1) = noprof
            endif
!
!         KAUX := POINTEUR PERMETTANT DE SE PLACER DANS PROMED
!         POUR LA PROCHAINE IMPRESSION
            kaux = kaux + zi(jaux+6)
        endif
    enddo
!
!====
! 8. LA FIN
!====
    if (nivinf .gt. 1) then
        if (typech(1:4) .eq. 'ELGA') then
            write (ifm,801)
        else
            write (ifm,804)
        endif
        do iaux = 1 , nbimpr
            jaux = adcaii+10*(iaux-1)
            if (zi(jaux+6) .gt. 0) write (ifm, 802) nomtyp(zi(jaux+7)), zi(jaux+6),&
                                zi(jaux+1), zi(jaux+2)
        enddo
        write (ifm,803)
        write (ifm,805) 'FIN DE IRCMPE'
    endif
801 format(4x,65('*'),/,4x,'*  TYPE DE *',22x,'NOMBRE DE',21x,'*',&
     &/,4x,'*  MAILLE  *  VALEURS   * POINT(S) DE GAUSS *',&
     &     '   SOUS_POINT(S)   *',/,4x,65('*'))
802 format(4x,'* ',a8,' *',i11,' *',i15,'    *',i15,'    *')
803 format(4x,65('*'))
804 format(4x,65('*'),/,4x,'*  TYPE DE *',22x,'NOMBRE DE',21x,'*',&
     &/,4x,'*  MAILLE  *  VALEURS   *      POINTS       *',&
     &     '   SOUS_POINT(S)   *',/,4x,65('*'))
805 format(/,4x,10('='),a,10('='),/)
999 continue
!
end subroutine
