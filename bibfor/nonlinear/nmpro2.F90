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

subroutine nmpro2(fonact, numedd, numfix)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/copisd.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    character(len=24) :: numedd, numfix
    integer :: fonact(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! DUPLICATION DU NUME_DDL - CREATION DU NUME_DDL 'FIXE'
!
! ----------------------------------------------------------------------
!
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! OUT NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
!
!
!
!
    aster_logical :: lmacr, leltc
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- FONCTIONNALITES ACTIVEES
!
    lmacr = isfonc(fonact,'MACR_ELEM_STAT')
    leltc = isfonc(fonact,'ELT_CONTACT')
!
! --- DUPLICATION (OU PAS !)
!
    if (leltc .and. lmacr) then
        numfix = '&&NMPRO2.NUMFIX'
        call copisd('NUME_DDL', 'V', numedd, numfix)
    else
        numfix = numedd
    endif
!
    call jedema()
!
end subroutine
