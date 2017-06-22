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

subroutine cgverc(resu, nexci)
    implicit none
!
#include "asterfort/gettco.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: nexci
    character(len=8) :: resu
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : VERIFICATION DE LA COMPATIBILITE ENTRE EXCIT ET RESU
!
!  IN :
!     RESU   : MOT-CLE RESULTAT
!     NEXCI  : NOMBRE D'OCCURENCES DU MOT-CLE FACTEUR EXCIT
!  OUT :
! ======================================================================
!
    character(len=16) :: typsd
!
    call jemarq()
!
    call gettco(resu, typsd)
!
    if (typsd .eq. 'DYNA_TRANS') then
!
!       LES RESULTATS DE TYPE DYNA_TRANS NE CONTIENNENT PAS DE CHARGES
!       LE MOT-CLE EXCIT EST DONC OBLIGATOIRE
        if (nexci .eq. 0) then
            call utmess('F', 'RUPTURE0_9')
        endif
!
    else
!
!       POUR LES AUTRES TYPE DE RESULTAT, EXCIT N'EST PAS CONSEILLE
!       (SAUF SI LE RESU PROVIENT DE CREA_RESU, VOIR TEXTE ALARME)
        if (nexci .ne. 0) then
            call utmess('A', 'RUPTURE0_55')
        endif
!
    endif
!
    call jedema()
!
end subroutine
