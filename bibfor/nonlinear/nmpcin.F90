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

subroutine nmpcin(matass)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=19) :: matass
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! RETOUR DU POINTEUR SUR LES DDLS ELIMINES PAR AFFE_CHAR_CINE
!
! ----------------------------------------------------------------------
!
!
! IN  MATASS : MATRICE DU PREMIER MEMBRE ASSEMBLEE
!
!
!
!
    integer :: jrefa, jccid
    aster_logical :: lvcine
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LA MATRICE DOIT EXISTER. SINON ON NE NE PEUT PAS DEVINER
! --- LES DDLS IMPOSES PAR AFFE_CHAR_CINE :
!
    call jeexin(matass(1:19)//'.REFA', jrefa)
    if (jrefa .eq. 0) then
        call utmess('F', 'ALGELINE2_88', sk=matass)
    endif
!
! --- ACCES POINTEUR
!
    call jeexin(matass(1:19)//'.CCID', jccid)
    lvcine = (jccid.gt.0)
    if (lvcine) then
        call jeveuo(matass(1:19)//'.CCID', 'L', jccid)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
