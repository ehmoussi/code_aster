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

subroutine vtdefs(chpout, chpin, base, typc)
!     DEFINITION DE LA STRUCTURE D'UN CHAM_NO OU CHAM_ELEM "CHPOUT"
!                    QUI S'APPUIE SUR LA MEME NUMEROTATION QUE "CHPIN",
!     LE CHAM_... "CHPOUT" EST CREEE SUR LA BASE "BASE".
!     LE CHAM_... "CHPOUT" EST A COEFFICIENTS "TYPE".
!     ------------------------------------------------------------------
! IN : CHPOUT : NOM DU CHAM_NO OU CHAM_ELEM A CREER
! IN : CHPIN  : NOM DU CHAM_NO OU CHAM_ELEM MODELE
! IN : BASE   : NOM DE LA BASE SUR LAQUELLE LE CHAM_... DOIT ETRE CREER
! IN : TYPC   : TYPE DES VALEURS DU CHAM_... A CREER
!                    'R'  ==> COEFFICIENTS REELS
!                    'C'  ==> COEFFICIENTS COMPLEXES
!                    ' '  ==> COEFFICIENTS DU TYPE DU CHAM_... CHPIN
!     ------------------------------------------------------------------
!     PRECAUTIONS D'EMPLOI :
!       1) LE CHAM_... "CHPOUT" NE DOIT PAS EXISTER
!       2) LES COEFFICIENTS DU CHAM_... "CHPOUT" NE SONT PAS AFFECTES
!----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/gcncon.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/vtdef1.h"
#include "asterfort/wkvect.h"
!
    character(len=*) :: chpout, chpin, base, typc
!
! DECLARATION VARIABLES LOCALES
    character(len=4) :: tych
    character(len=19) :: ch19, arg1, arg2
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    ch19 = chpin
!
    call dismoi('TYPE_CHAMP', ch19, 'CHAMP', repk=tych)
!
    arg1=chpout
    arg2=chpin
    call vtdef1(arg1, arg2, base, typc)
    call jedema()
!
end subroutine
