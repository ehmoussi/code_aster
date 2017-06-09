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

subroutine cfinvm(defico, jdeciv, ima, posma)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: defico
    integer :: jdeciv, ima, posma
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! MAILLE ATTACHEE AU NOEUD (CONNECTIVITE INVERSE)
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE CONTACT (DEFINITION)
! IN  IMA    : NUMERO ORDRE DE LA MAILLE DANS SD CONN. INVERSE.
! IN  JDECIV : DECALAGE POUR LECTURE DANS SD CONN. INVERSE.
! OUT POSMA  : POSITION DE LA MAILLE
!
!
!
!
    character(len=24) :: manoco
    integer :: jmano
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD DE CONTACT
!
    manoco = defico(1:16)//'.MANOCO'
    call jeveuo(manoco, 'L', jmano)
!
! --- REPONSE
!
    if (jdeciv .eq. -1) then
        ASSERT(.false.)
    endif
    posma = zi(jmano+jdeciv+ima-1)
!
    call jedema()
!
end subroutine
