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

subroutine mdnoma(nomamd, lnomam, nomast, codret)
!_____________________________________________________________________
! person_in_charge: nicolas.sellenet at edf.fr
!        FORMAT MED : ELABORATION D'UN NOM DE MAILLAGE DANS LE FICHIER
!               - -                    --     --
!_____________________________________________________________________
!
!   LA REGLE EST LA SUIVANTE :
!
!     LE NOM EST LIMITE A 64 CARACTERES DANS MED. ON UTILISE ICI
!     AU MAXIMUM 8 CARACTERES.
!                 12345678901234567890123456789012
!                 AAAAAAAA
!       AAAAAAAA : NOM DU MAILLAGE DANS ASTER
!
!
!     SORTIES :
!       NOMAMD : NOM DU MAILLAGE DANS LE FICHIER MED
!       LNOMAM : LONGUEUR UTILE DU NOM DU MAILLAGE DANS LE FICHIER MED
!       CODRET : CODE DE RETOUR DE L'OPERATION
!                0 --> TOUT VA BIEN
!                1 --> LA DECLARATION DU NOM DE L'OBJET NE CONVIENT PAS
!               10 --> AUTRE PROBLEME
!    ENTREES :
!       NOMAST : NOM DU MAILLAGE ASTER
!_____________________________________________________________________
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
    character(len=64) :: nomamd
    character(len=8) :: nomast
!
    integer :: lnomam
    integer :: codret
!
! 0.2. ==> COMMUNS
!
! 0.3. ==> VARIABLES LOCALES
!
!
!
    integer :: iaux
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
!               12345678901234567890123456789012
        nomamd = '                                '//'                          '
!
! 2.2. ==> NOM DU MAILLAGE
!
        iaux = lxlgut(nomast)
        ASSERT(iaux.ge.1 .and. iaux.le.8)
        nomamd(1:iaux) = nomast(1:iaux)
        lnomam = iaux
!
    endif
!
!====
! 3. BILAN
!====
!
    if (codret .ne. 0) then
        call utmess('E', 'MED_62')
    endif
!
end subroutine
