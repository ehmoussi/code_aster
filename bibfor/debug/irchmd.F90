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

subroutine irchmd(ifichi, chanom, partie, nochmd, codret)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/irchme.h"
    character(len=19) :: chanom
    character(len=*) :: partie, nochmd
!
    integer :: ifichi, codret
! person_in_charge: nicolas.sellenet at edf.fr
!        UTILITAIRE D'IMPRESSION DU CHAMP CHANOM NOEUD/ELEMENT
!        ENTIER/REEL AU FORMAT MED
!     ENTREES:
!        IFICHI : UNITE LOGIQUE D'IMPRESSION DU CHAMP
!        CHANOM : NOM ASTER DU CHAM A ECRIRE
!        PARTIE : IMPRESSION DE LA PARTIE IMAGINAIRE OU REELLE POUR
!                  UN CHAMP COMPLEXE AU FORMAT CASTEM OU GMSH OU MED
!        NOCHMD : NOM DU CHAMP DANS LE FICHIER MED (CHOIX DE
!                  L'UTILISATEUR)
!     SORTIES:
!        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
!
    integer :: numord
!
    character(len=8) :: typech, noresu, sdcarm
    character(len=16) :: nomsym
    character(len=19) :: chan19, nopara
    character(len=64) :: noch64
    parameter (sdcarm = ' ')
!
    chan19=chanom
    noch64=nochmd
    call dismoi('TYPE_CHAMP', chan19, 'CHAMP', repk=typech)
!
    noresu=' '
    nomsym=' '
    nopara=' '
    numord=0
    call irchme(ifichi, chan19, partie, noch64, noresu,&
                nomsym, typech, numord, 0, [' '],&
                0, [0], 0, [0], .false._1,&
                sdcarm, sdcarm, nopara, codret)
!
end subroutine
