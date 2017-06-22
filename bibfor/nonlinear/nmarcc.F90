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

subroutine nmarcc(result, numarc, typchz, nomchz)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
    character(len=8) :: result
    character(len=*) :: typchz, nomchz
    integer :: numarc
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (ALGORITHME - ARCHIVAGE)
!
! ARCHIVAGE D'UN CHAMP
!
! ----------------------------------------------------------------------
!
!
! IN  RESULT : NOM UTILISATEUR DU CONCEPT RESULTAT
! IN  NOMCHA : NOM DU CHAMP
! IN  TYPCHA : NOM DU CHAMP DANS SD RESULTAT
! IN  NUMARC : NUMERO D'ARCHIVAGE
!
!
!
!
    integer :: iret
    character(len=19) :: champ, nomcha
    character(len=24) :: typcha
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    typcha = typchz
    nomcha = nomchz
    champ = ' '
!
! --- ACCES AU CHAMP DANS SD RESULTAT
!
    call rsexch(' ', result, typcha, numarc, champ,&
                iret)
    if (iret .gt. 100) then
        ASSERT(.false.)
    endif
!
! --- COPIE DU CHAMP DANS SD RESULTAT
!
    call copisd('CHAMP_GD', 'G', nomcha, champ)
    call rsnoch(result, typcha, numarc)
!
    call jedema()
end subroutine
