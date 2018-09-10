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

subroutine irceme(ifi, nochmd, chanom, typech, modele,&
                  nbcmp, nomcmp, etiqcp, partie, numpt,&
                  instan, numord, nbmaec, limaec, sdcarm,&
                  carael, codret)
!_______________________________________________________________________
! person_in_charge: nicolas.sellenet at edf.fr
!        IMPRESSION DU CHAMP CHANOM ELEMENT ENTIER/REEL
!        AU FORMAT MED
!     ENTREES:
!       IFI    : UNITE LOGIQUE D'IMPRESSION DU CHAMP
!       NOCHMD : NOM MED DU CHAM A ECRIRE
!       PARTIE: IMPRESSION DE LA PARTIE IMAGINAIRE OU REELLE POUR
!               UN CHAMP COMPLEXE
!       CHANOM : NOM ASTER DU CHAM A ECRIRE
!       TYPECH : TYPE DU CHAMP
!       MODELE : MODELE ASSOCIE AU CHAMP
!       NBCMP  : NOMBRE DE COMPOSANTES A ECRIRE
!       NOMCMP : NOMS DES COMPOSANTES A ECRIRE
!       ETIQCP : NOMS DES COMPOSANTES A DONNER A MED (LABEL)
!       NUMPT  : NUMERO DE PAS DE TEMPS
!       INSTAN : VALEUR DE L'INSTANT A ARCHIVER
!       NUMORD : NUMERO D'ORDRE DU CHAMP
!       NBMAEC : NOMBRE DE MAILLES A ECRIRE (0, SI TOUTES LES MAILLES)
!       LIMAEC : LISTE DES MAILLES A ECRIRE SI EXTRAIT
!       SDCARM : CARA_ELEM (UTILE POUR LES SOUS-POINTS)
!    SORTIES:
!       CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
! -------------------------------------------------------------------
!     ASTER INFORMATIONS:
!_______________________________________________________________________
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterfort/carces.h"
#include "asterfort/celces.h"
#include "asterfort/detrsd.h"
#include "asterfort/ircame.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=8) :: typech, modele, sdcarm, carael
    character(len=19) :: chanom
    character(len=64) :: nochmd
    character(len=*) :: nomcmp(*), partie, etiqcp
!
    integer :: nbcmp, numpt, numord
    integer :: nbmaec, cret
    integer :: ifi, limaec(*)
!
    real(kind=8) :: instan
!
    integer :: codret
!
! 0.2. ==> COMMUNS
! 0.3. ==> VARIABLES LOCALES
!
    character(len=6) :: nompro
    parameter ( nompro = 'IRCEME' )
!
    character(len=19) :: chamns
!
    integer :: jcesk, jcesd, jcesc, jcesv, jcesl
!     ------------------------------------------------------------------
!
    call jemarq()
!
!====
! 1. PREALABLE
!====
!
!    --- CONVERSION CHAM_ELEM -> CHAM_ELEM_S
!               1234567890123456789
    chamns = '&&      .CES.MED'
    chamns(3:8) = nompro
    if (typech .eq. 'CART') then
        call carces(chanom, 'ELEM', ' ', 'V', chamns,&
                    ' ', cret)
        typech = 'ELEM'
    else
        call celces(chanom, 'V', chamns)
    endif
!
!    --- ON RECUPERE LES OBJETS
!
    call jeveuo(chamns//'.CESK', 'L', jcesk)
    call jeveuo(chamns//'.CESD', 'L', jcesd)
    call jeveuo(chamns//'.CESC', 'L', jcesc)
    call jeveuo(chamns//'.CESV', 'L', jcesv)
    call jeveuo(chamns//'.CESL', 'L', jcesl)
!
!====
! 2. ECRITURE DES CHAMPS AU FORMAT MED
!====
!
    call ircame(ifi, nochmd, chanom, typech, modele,&
                nbcmp, nomcmp, etiqcp, partie, numpt,&
                instan, numord, jcesk, jcesd, jcesc,&
                jcesv, jcesl, nbmaec, limaec, sdcarm,&
                carael, codret)
!
!====
! 3. ON NETTOIE
!====
!
    call detrsd('CHAM_ELEM_S', chamns)
!
!====
! 4. BILAN
!====
!
    if (codret .ne. 0 .and. codret .ne. 100) then
        call utmess('A', 'MED_89', sk=chanom)
    endif
!
    call jedema()
!
end subroutine
