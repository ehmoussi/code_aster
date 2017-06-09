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

subroutine cgvefo(option, typfis, nomfis, typdis)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: typfis, nomfis
    character(len=16) :: option, typdis
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : VERIFICATION DE LA COMPATIBILITE ENTRE
!           OPTION ET TYPE DE FISSURE
!
!  IN :
!    OPTION : OPTION DE CALC_G
!    TYPFIS : TYPE DE LA SD DECRIVANT LE FOND DE FISSURE
!             ('THETA' OU 'FONDIFSS' OU 'FISSURE')
!    NOMFIS : NOM DE LA SD DECRIVANT LE FOND DE FISSURE
!    TYPDIS : TYPE DE DISCONTINUITE SI FISSURE XFEM 
!             'FISSURE' OU 'COHESIF'
! ======================================================================
!
    integer :: ier
    character(len=8) :: conf
!
    call jemarq()
!
!     LE CAS DES FONDS DOUBLES N'EST PAS TRAITE DANS CALC_G
    if (typfis .eq. 'FONDFISS') then
        call jeexin(nomfis//'.FOND.NOEU', ier)
        if (ier .eq. 0) then
            call utmess('F', 'RUPTURE1_4')
        endif
    endif
!
!     COMPATIBILITE ENTRE OPTION ET "ENTAILLE"
!     ON NE SAIT DEFINIR K QUE DANS LE CAS D'UNE FISSURE AVEC LEVRES
!     INITIALLEMENT COLLEES (PAS D'ENTAILLE), DONC
!     CERTAINES OPTIONS EN MODELISATION FEM NE TRAITENT PAS LES
!     FISSURES EN CONFIGURATION DECOLLEE
!     (SI X-FEM OU THETA, LA CONFIG ET TOUJOURS COLLEE)
    if (typfis .eq. 'FONDFISS') then
!
        call dismoi('CONFIG_INIT', nomfis, 'FOND_FISS', repk=conf)
!
        if ((option .eq. 'CALC_K_G' .or. option .eq. 'K_G_MODA')&
            .and. (conf.eq.'DECOLLEE')) then
            call utmess('F', 'RUPTURE0_29', sk=option)
        endif
!
    endif
!
!   SI FISSURE TYPE 'COHESIF', LA SEULE OPTION EST CALC_K_G
    if(typdis.eq.'COHESIF'.and.option.ne.'CALC_K_G') then
        call utmess('F','RUPTURE2_5')
    endif
!
!
    call jedema()
!
end subroutine
