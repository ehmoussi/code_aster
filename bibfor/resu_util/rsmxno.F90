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

function rsmxno(nomsd)
    implicit none
    integer :: rsmxno
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: nomsd
!      RENVOIE LA VALEUR MAXIMALE DU NUMERO D'ORDRE (IORDR)
! ----------------------------------------------------------------------
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
    character(len=19) :: nomd2
    integer :: nbordr,  k, ival
    integer, pointer :: ordr(:) => null()
! ----------------------------------------------------------------------
    call jemarq()
    ival = 0
    nomd2 = nomsd
!
    call jelira(nomd2//'.ORDR', 'LONUTI', nbordr)
    if (nbordr .gt. 0) then
        call jeveuo(nomd2//'.ORDR', 'L', vi=ordr)
        ival = ordr(1)
        do 10 k = 1, nbordr
            ival = max (ival,ordr(k))
10      continue
    endif
    rsmxno = ival
!
    call jedema()
end function
