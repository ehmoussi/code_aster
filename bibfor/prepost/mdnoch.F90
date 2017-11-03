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

subroutine mdnoch(nochmd, lnochm, lresu, noresu, nomsym,&
                  codret)
!_____________________________________________________________________
! person_in_charge: nicolas.sellenet at edf.fr
!_____________________________________________________________________
!        FORMAT MED : ELABORATION D'UN NOM DE CHAMP DANS LE FICHIER
!               - -                    --     --
!_____________________________________________________________________
!
!   LA REGLE EST LA SUIVANTE :
!
!     LE NOM EST LIMITE A 64 CARACTERES DANS MED. ON UTILISE ICI
!     EXACTEMENT 64 CARACTERES.
!       . POUR UN CHAMP ISSU D'UNE STRUCTURE DE RESULTAT :
!                 12345678901234567890123456789012
!                 AAAAAAAABBBBBBBBBBBBBBBBCCCCCCCC
!       AAAAAAAA : NOM DU RESULTAT D'OU PROVIENT LE CHAMP A IMPRIMER
!       BBBBBBBBBBBBBBBB : NOM SYMBOLIQUE DU CHAMP
!       CCCCCCCC : NOM D'UN PARAMETRE EVENTUEL
!       . POUR UN CHAMP DE GRANDEUR :
!                 12345678901234567890123456789012
!                 AAAAAAAA
!       AAAAAAAA : NOM DE LA GRANDEUR A IMPRIMER
!
!   REMARQUE :
!       LES EVENTUELS BLANCS SONT REMPLACES PAR DES '_'
!
!   EXEMPLE :
!     . CHAMP DE GRANDEUR 'EXTRRESU' :
!                 12345678901234567890123456789012
!       NOCHMD = 'EXTRRESU________________________'
!
!     SORTIES :
!       NOCHMD : NOM DU CHAMP DANS LE FICHIER MED
!       LNOCHM : LONGUEUR UTILE DU NOM DU CHAMP DANS LE FICHIER MED
!       CODRET : CODE DE RETOUR DE L'OPERATION
!                0 --> TOUT VA BIEN
!                1 --> LA DECLARATION DU NOM DE L'OBJET NE CONVIENT PAS
!               10 --> AUTRE PROBLEME
!    ENTREES :
!       LRESU  : 1 (.true.) : INDIQUE IMPRESSION D'UN CONCEPT RESULTAT
!                0 (.false.) : IMPRESSION D'UN CHAMP GRANDEUR
!       NORESU : NOM DU RESULTAT D'OU PROVIENT LE CHAMP A IMPRIMER
!       NOMSYM : NOM SYMBOLIQUE DU CHAMP, SI RESULTAT
!                CHAINE BLANCHE SI GRANDEUR
!_____________________________________________________________________
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterfort/assert.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
    character(len=64) :: nochmd
    character(len=16) :: nomsym
    character(len=8) :: noresu
!
    integer :: lresu
!
    integer :: lnochm
    integer :: codret
!
! 0.2. ==> COMMUNS
!
! 0.3. ==> VARIABLES LOCALES
!
!
    integer :: iaux, jaux
!
!====
! 1. PREALABLES
!====
!
    codret = 0
!
!====
! 2. CREATION DU NOM
!====
!
    if (codret .eq. 0) then
!
! 2.1. ==> BLANCHIMENT INITIAL
!
        do iaux = 1 , 64
            nochmd(iaux:iaux) = ' '
        end do
!
! 2.2. ==> NOM DU RESULTAT
!
        jaux = lxlgut(noresu)
        ASSERT(jaux.ge.1 .and. jaux.le.8)
!
        lnochm = jaux
        nochmd(1:lnochm) = noresu(1:lnochm)
!
! 2.3. ==> NOM SYMBOLIQUE DU CHAMP
!
        if (lresu .eq. 1) then
!
            jaux = lxlgut(nomsym)
            ASSERT(jaux.ge.1 .and. jaux.le.16)
!
            do iaux = lnochm+1 , 8
                nochmd(iaux:iaux) = '_'
            end do
            lnochm = 8+jaux
            nochmd(9:8+jaux) = nomsym(1:jaux)
!
        endif
!
    endif
!
!====
! 3. BILAN
!====
!
    if (codret .ne. 0) then
        call utmess('F', 'MED_91')
    endif
!
end subroutine
