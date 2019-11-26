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

subroutine irmpg1(nofimd, nomfpg, nbnoto, nbrepg, nbsp,&
                  ndim, typgeo, refcoo, gscoo, wg,&
                  raux1, raux2, raux3, nolopg, nomasu,&
                  codret)
! person_in_charge: nicolas.sellenet at edf.fr
!_______________________________________________________________________
!     ECRITURE AU FORMAT MED - LOCALISATION POINTS DE GAUSS - PHASE 1
!        -  -            -                  -         -             -
!_______________________________________________________________________
!     ENTREES :
!       NOFIMD : NOM DU FICHIER MED
!       NOMFPG : NOM DE LA FAMILLE DES POINTS DE GAUSS
!       NBNOTO : NOMBRE DE NOEUDS TOTAL
!       NBREPG : NOMBRE DE POINTS DE GAUSS
!       NBSP   : NOMBRE DE SOUS-POINTS
!       NDIM   : DIMENSION DE L'ELEMENT
!       TYPGEO : TYPE GEOMETRIQUE DE LA MAILLE ASSOCIEE
!       REFCOO : COORDONNEES DES NBNOTO NOEUDS
!       GSCOO  : COORDONNEES DES POINTS DE GAUSS, SI CHAMP ELGA
!       WG     : POIDS DES POINTS DE GAUSS, SI CHAMP ELGA
!       RAUX1, RAUX2, RAUX3 : TABLEAUX REELS AUXILIAIRES
!     SORTIES :
!       NOLOPG : NON DE LA LOCALISATION ECRITE
!       CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
!
!     REMARQUE :
!     ON DOIT FOURNIR LES COORDONNEES SOUS LA FORME :
!     . ELEMENT 1D : X1 X2 ... ... XN
!     . ELEMENT 2D : X1 Y1 X2 Y2 ... ... XN YN
!     . ELEMENT 3D : X1 Y1 Z1 X2 Y2 Z2 ... ... XN YN ZN
!     C'EST CE QUE MED APPELLE LE MODE ENTRELACE
!     ON DOIT FOURNIR LES POIDS SOUS LA FORME :
!     WG1 WG2 ... ... WGN
!_______________________________________________________________________
!
    use as_med_module, only: as_med_open
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterf_types.h"
#include "asterfort/as_mficlo.h"
#include "asterfort/as_mlclci.h"
#include "asterfort/as_mlclor.h"
#include "asterfort/as_mlclow.h"
#include "asterfort/as_mlcnlc.h"
#include "asterfort/codent.h"
#include "asterfort/infniv.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
!
    integer :: nbnoto, nbrepg, nbsp, ndim, typgeo
!
    real(kind=8) :: refcoo(*), gscoo(*), wg(*)
    real(kind=8) :: raux1(*), raux2(*), raux3(*)
!
    character(len=16) :: nomfpg
    character(len=*) :: nolopg, nomasu
    character(len=*) :: nofimd
!
    integer :: codret
!
! 0.2. ==> COMMUNS
! 0.3. ==> VARIABLES LOCALES
!
    character(len=6) :: nompro
    parameter ( nompro = 'IRMPG1' )
!
    integer :: edfuin
    parameter (edfuin=0)
    integer :: edleaj
    parameter (edleaj=1)
!
    integer :: ifm, nivinf
    integer :: iaux, jaux, kaux
    integer :: nblopg
    med_idt :: idfimd
    integer :: typgel, nbrepl, ndim2
    integer :: lgnofa
!
!
    character(len=8) :: saux08
    character(len=16) :: saux16
    character(len=64) :: saux64, nomas2
    aster_logical :: ficexi
!
!====
! 1. PREALABLES
!====
!
! 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
!
    call infniv(ifm, nivinf)
!
! 1.2. ==> INFORMATION
!
    if (nivinf .gt. 1) then
        write (ifm,201) 'DEBUT DE '//nompro
        write (ifm,202) nomfpg
        202 format(/,'ECRITURE D''UNE LOCALISATION DES POINTS DE GAUSS',&
     &       /,'==> NOM DE LA FAMILLE D''ELEMENT FINI ASSOCIEE : ',a)
    endif
    201 format(/,4x,10('='),a,10('='),/)
!
! 1.3. ==> OUVERTURE FICHIER MED EN MODE 'LECTURE_AJOUT'
!      CELA SIGNIFIE QUE LE FICHIER EST ENRICHI MAIS ON NE PEUT PAS
!      Y ECRASER UNE DONNEE DEJA PRESENTE.
!      REMARQUE : LE FICHIER EXISTE DEJA CAR IL CONTIENT LE MAILLAGE.
!
    inquire(file=nofimd,exist=ficexi)
    if (.not. ficexi) then
        call utmess('F', 'MED2_3')
    endif
    call as_med_open(idfimd, nofimd, edleaj, codret)
    if (codret .ne. 0) then
        saux08='mfiope'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
! 1.4. ==> CREATION DE LA PRMIERE MOITIE DU NOM DE LA LOCALISATION :
!          ON L'IDENTIFIE AU NOM DE LA FAMILLE, EN REMPLACANT LES BLANCS
!          INTERNES PAR DES '_'
!
    saux16 = '                '
!             1234567890123456
    lgnofa = lxlgut(nomfpg)
    saux16(1:lgnofa) = nomfpg(1:lgnofa)
    do iaux = 1 , lgnofa
        if (saux16(iaux:iaux) .eq. ' ') then
            saux16(iaux:iaux) = '_'
        endif
    end do
!
!====
! 2. ON CHERCHE SI UNE DESCRIPTION IDENTIQUE EXISTE DEJA DANS LE
!    FICHIER. SI OUI, ON LA DECLARE COMME ETANT CELLE A UTILISER.
!====
!
! 2.1. ==> COMBIEN DE LOCALISATIONS SONT PRESENTES DANS LE FICHIER
!
    call as_mlcnlc(idfimd, nblopg, codret)
!
    if (codret .ne. 0) then
        saux08='mlcnlc'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
!
    if (nivinf .gt. 1) then
        if (nblopg .eq. 0) then
            write (ifm,203)
        else
            write (ifm,204) nblopg
        endif
    endif
    203 format(/,2x,'LE FICHIER NE CONTIENT PAS DE',&
     &' LOCALISATION DE POINTS DE GAUSS.')
    204 format(/,2x,'LE FICHIER CONTIENT DEJA',i8,&
     &' LOCALISATION(S) DE POINTS DE GAUSS : ')
!
! 2.2. ==> PARCOURS DES LOCALISATIONS DEJA ENREGISTREES
!
    do iaux = 1 , nblopg
!
! 2.2.1. ==> LECTURE DES CARACTERISTIQUES DE LA IAUX-EME LOCALISATION
!              PRESENTE DANS LE FICHIER :
!              SAUX64 = NOM
!              TYPGEL = TYPGEO
!              NBREPL = NOMBRE DE POINTS DE GAUSS
!
        call as_mlclci(idfimd, iaux, saux64, typgel, nbrepl,&
                   ndim2, nomas2, codret)
!
        if (codret .ne. 0) then
            saux08='mlclci'
            call utmess('F', 'DVP_97', sk=saux08, si=codret)
        endif
!
        if (nivinf .gt. 1) then
            write (ifm,205) iaux, saux64, typgel, nbrepl
        endif
        205 format(&
        & /,2x,'. CARACTERISTIQUES DE LA LOCALISATION NUMERO',i4,' : ',&
        & /,2x,'... NOM    : ',a,&
        & /,2x,'... TYPGEO :',i4,&
        & /,2x,'... NBREPG :',i4)
!
! 2.2.2. ==> ON REPERE SI LA LOCALISATION EST BATIE SUR LA MEME
!            FAMILLE D'ELEMENT FINI ASTER.
!            ON PEUT DEJA FILTRER SUR LE TYPE D'ELEMENT FINI
!            ENSUITE, SI LES CARACTERISTIQUES SONT LES MEMES, ON LIT LES
!            POIDS ET LES COORDONNEES ET LES ON COMPARE A CEUX DE
!            LA LOCALISATION VOULUE.
!            DES QUE L'ON TROUVE UN TERME DIFFERENT, ON PASSE A LA
!            LOCALISATION SUIVANTE.
!
        if (saux64(1:lgnofa) .eq. saux16(1:lgnofa) .and. nomas2 .eq. nomasu) then
!
!
            if (typgel .eq. typgeo .and. nbrepl .eq. nbrepg) then
!
                call as_mlclor(idfimd, raux1, raux2, raux3, edfuin,&
                           saux64, codret)
!
                if (codret .ne. 0) then
                    saux08='mlclor'
                    call utmess('F', 'DVP_97', sk=saux08, si=codret)
                endif
!
                kaux = nbnoto*ndim
                do jaux = 1 , kaux
                    if (refcoo(jaux) .ne. raux1(jaux)) then
                        goto 22
                    endif
                end do
                kaux = nbrepg*ndim
                do jaux = 1 , kaux
                    if (gscoo(jaux) .ne. raux2(jaux)) then
                        goto 22
                    endif
                end do
                do jaux = 1 , nbrepg
                    if (wg(jaux) .ne. raux3(jaux)) then
                        goto 22
                    endif
                end do
!
!           SI ON ARRIVE ICI, C'EST QUE LES LOCALISATIONS SONT
!           IDENTIQUES ; ON LE NOTIFIE ET ON TERMINE LE PROGRAMME
!
                if (nivinf .gt. 1) then
                    write (ifm,206) saux64
                endif
                206 format(/,2x,'LA LOCALISATION ',a,' EST LA BONNE.')
!
                nolopg = saux64
!
                goto 40
!
            endif
!
        endif
!
22 continue
!
    end do
!
!====
! 3. ON DOIT ECRIRE UNE NOUVELLE LOCALISATION
!    ON LUI CREE UN NOM AUTOMATIQUE.
!    ON S'ASSURE QUE LE NOM CREE N'EXISTE PAS DEJA DANS LE FICHIER
!====
!
! 3.0. ==> IMPRESSION EVENTUELLE DES CARACTERISTIQUES
!
    if (nivinf .gt. 1) then
!
        write (ifm,*) ' '
        write (ifm,207) 'FAMILLE DE POINTS DE GAUSS', nomfpg
        write (ifm,208) 'NOMBRE DE NOEUDS          ', nbnoto
        write (ifm,208) 'NOMBRE DE POINTS DE GAUSS ', nbrepg
!
!     6.1. DIMENSION 1
!
        if (ndim .eq. 1) then
!                            123456789012345
            write (ifm,209) 'NOEUDS         '
            do iaux = 1 , nbnoto
                write (ifm,210) iaux,refcoo(iaux)
            end do
            write (ifm,211)
            write (ifm,209) 'POINTS DE GAUSS'
            do iaux = 1 , nbrepg
                write (ifm,210) iaux,gscoo(iaux)
            end do
            write (ifm,211)
!
!     6.2. DIMENSION 2
!
        else if (ndim.eq.2) then
            write (ifm,212) 'NOEUDS         '
            do iaux = 1 , nbnoto
                write (ifm,213) iaux, refcoo(ndim*(iaux-1)+1),&
                refcoo(ndim*(iaux-1)+2)
            end do
            write (ifm,214)
            write (ifm,212) 'POINTS DE GAUSS'
            do iaux = 1 , nbrepg
                write (ifm,213) iaux, gscoo(ndim*(iaux-1)+1),&
                gscoo(ndim*(iaux-1)+2)
            end do
            write (ifm,214)
!
!     6.3. DIMENSION 3
!
        else
            write (ifm,215) 'NOEUDS         '
            do iaux = 1 , nbnoto
                write (ifm,217) iaux, refcoo(ndim*(iaux-1)+1),&
                refcoo(ndim*(iaux-1)+2), refcoo(ndim*(iaux-1)+3)
            end do
            write (ifm,216)
            write (ifm,215) 'POINTS DE GAUSS'
            do iaux = 1 , nbrepg
                write (ifm,217) iaux, gscoo(ndim*(iaux-1)+1),&
                gscoo(ndim*(iaux-1)+2), gscoo(ndim*(iaux-1)+3)
            end do
            write (ifm,216)
        endif
!
        write (ifm,218)
        do iaux = 1 , nbrepg
            write (ifm,210) iaux, wg(iaux)
        end do
        write (ifm,211)
!
    endif
!
    209 format(&
     &/,28('*'),&
     &/,'*      COORDONNEES DES     *',&
     &/,'*      ',a15        ,'     *',&
     &/,28('*'),&
     &/,'*  NUMERO  *       X       *',&
     &/,28('*'))
    212 format(&
     &/,44('*'),&
     &/,'*       COORDONNEES DES ',a15        ,'    *',&
     &/,44('*'),&
     &/,'*  NUMERO  *       X       *       Y       *',&
     &/,44('*'))
    215 format(&
     &/,60('*'),&
     &/,'*            COORDONNEES DES ',a15         ,&
     &'               *',&
     &/,60('*'),&
     &/,'*  NUMERO  *       X       *       Y       *',&
     &'       Z       *',&
     &/,60('*'))
    218 format(&
     &/,28('*'),&
     &/,'*      POINTS DE GAUSS     *',&
     &/,'*  NUMERO  *     POIDS     *',&
     &/,28('*'))
    210 format('* ',i5,'    *',1pg12.5,'    *')
    213 format('* ',i5,2('    *',1pg12.5),'    *')
    217 format('* ',i5,3('    *',1pg12.5),'    *')
    211 format(28('*'))
    214 format(44('*'))
    216 format(60('*'))
    207 format(a,' : ',a)
    208 format(a,' : ',i4)
!
    kaux = -1
!
 30 continue
!
! 3.1. ==> CREATION D'UN NOM POUR LA LOCALISATION
!      NOLOPG( 1:16) = NOM DE LA FAMILLE DES POINTS DE GAUSS
!      NOLOPG(17:25) = NOMBRE DE SOUS-POINTS SI > 1
!      NOLOPG(26:32) = COMPTEUR AU DELA DE 1
!      LES MANQUES INTERNES SONT COMPLETES PAR DES '_'
!
!     EXEMPLE : HE8_____FPG8
!               QU4_____FPG4 __________________3
!               12345678901234567890123456789012
!
! 3.1.1 ==> MISE A BLANC
!
    nolopg =' '
!      1234567890123456789012345678901234567890123456789012345678901234
!
! 3.1.2 ==> INSERTION DU NOM DE LA FAMILLE
!
    nolopg(1:lgnofa) = nomfpg(1:lgnofa)
!
    do iaux = 1, lgnofa
        if (nolopg(iaux:iaux) .eq. ' ') then
            nolopg(iaux:iaux) = '_'
        endif
    end do
!
! 3.1.3 ==> INSERTION DU NOMBRE DE SOUS-POINTS SI > 1
!
    if (nbsp .gt. 1) then
        call codent(nbsp, 'D', saux08)
        nolopg(17:24) = saux08
        nolopg(33:40) = 'ASTER_SP'
        do iaux = 1, 40
            if (nolopg(iaux:iaux) .eq. ' ') then
                nolopg(iaux:iaux) = '_'
            endif
        enddo
    endif
!
! 3.1.4 ==> INSERTION DU COMPTEUR AU DELA DE 1
!
    kaux = kaux + 1
    if (kaux .gt. 0) then
        call codent(kaux, 'D', saux08)
        nolopg (25:32) = saux08
        do iaux = 1, 32
            if (nolopg(iaux:iaux) .eq. ' ') then
                nolopg(iaux:iaux) = '_'
            endif
        end do
    end if
!
! 3.2. ==> LECTURE DES CARACTERISTIQUES DE LA IAUX-EME LOCALISATION
!            PRESENTE DANS LE FICHIER :
!              SAUX64 = NOM
!              TYPGEL = TYPGEO
!              NBREPL = NOMBRE DE POINTS DE GAUSS
!          SI ON EN TROUVE UNE QUI PORTE LE MEME NOM, ON RECOMMENCE
!
    do iaux = 1 , nblopg
!
        call as_mlclci(idfimd, iaux, saux64, typgel, nbrepl,&
                   ndim2, nomas2, codret)
!
        if (codret .ne. 0) then
            saux08='mlclci'
            call utmess('F', 'DVP_97', sk=saux08, si=codret)
        endif
!
        if (saux64 .eq. nolopg) then
            goto 30
        endif
!
    end do
!
! 3.3. ==> ECRITURE DE LA NOUVELLE DESCRIPTION
!
    if (nivinf .gt. 1) then
!
        write (ifm,219) typgeo, nbnoto, nbrepg, nolopg
        219 format(&
        &/,'TYPE DE MAILLES MED :', i4,&
        &/,'NOMBRE DE NOEUDS          :', i4&
        &/,'NOMBRE DE POINTS DE GAUSS :', i4,&
        &/,'ECRITURE D''UNE NOUVELLE LOCALISATION DES POINTS DE GAUSS, ',&
        &  'NOMMEE : ',/,a,/)
!
    endif
!
    if (nomasu .ne. ' ') then
        nolopg(32:64)=nomasu(1:32)
    endif
!
    call as_mlclow(idfimd, typgeo, refcoo, edfuin, nbrepg,&
                   gscoo, wg, nolopg, ndim, nomasu,&
                   codret)
!
    if (codret .ne. 0) then
        saux08='mlclow'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
!====
! 4. LA FIN
!====
!
40 continue
!
! 4.1. ==> FERMETURE DU FICHIER MED
!
    call as_mficlo(idfimd, codret)
    if (codret .ne. 0) then
        saux08='mficlo'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
    if (nivinf .gt. 1) then
        write (ifm,201) 'FIN DE '//nompro
    endif
!
end subroutine
