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

subroutine exithm(modele, yathm, perman)
!    FONCTION REALISEE : DETECTE SI LE MODELE EST UNE MODELISATION THM
!    ON RETOURNE UN LOGIQUE VALANT VRAI OU FAUX SELON LE CAS ET LE NOM
!    DE LA MODELISATION EFFECTIVE
!    IL Y A ERREUR FATALE SI ON NE REUSSIT PAS A DECODER LE MODELE
!
!    ATTENTION, SI LA MODELISATION N'EST PAS LA MEME SUR TOUT LE
!    MAILLAGE, CELA NE MARCHE PAS. C'EST LA FAUTE A DISMOI.
!    IL FAUDRA FAIRE AUTREMENT. (SYMPA COMME CONSEIL)
!
!     ARGUMENTS:
!     ----------
! IN   MODELE : MODELE DU CALCUL
! OUT  YATHM  : VRAI, SI LA MODELISATION EST UNE MODELISATION THM
!               FAUX, SINON
! OUT  PERMAN : SI LA MODELISATION EST UNE MODELISATION THM :
!               VRAI, SI CALCUL PERMANENT, FAUX, SINON
! ......................................................................
!
!   -------------------------------------------------------------------
!     SUBROUTINES APPELLEES :
!       MESSAGE     : UTMESK
!       UTILITAIRES : DISMOI
!   -------------------------------------------------------------------
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterf_types.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
    character(len=8) :: modele
!
    aster_logical :: yathm, perman
!
! 0.2. ==> COMMUNS
! 0.3. ==> VARIABLES LOCALES
!
!
    character(len=5) :: repons
!
!====
! 1. A-T-ON DE LA THM DANS L'UNE DES MODELISATIONS ASSOCIEES AU MODELE ?
!    IL Y A ERREUR FATALE SI ON NE REUSSIT PAS A DECODER LE MODELE
!====
!
    call dismoi('EXI_THM', modele, 'MODELE', repk=repons)
!
    if (repons .eq. 'OUI') then
        yathm = .true.
        perman = .false.
    else if (repons.eq.'OUI_P') then
        yathm = .true.
        perman = .true.
    else if (repons.eq.'NON') then
        yathm = .false.
    else
        call utmess('F', 'UTILITAI_75', sk=repons)
    endif
!
end subroutine
