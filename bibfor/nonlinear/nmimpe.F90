! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine nmimpe(modele, limped)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
character(len=24) :: modele
aster_logical :: limped
!
!
!
!
!
    character(len=19) :: nolig, ligrel
    character(len=16) :: nomte
    character(len=24) :: repk
    integer :: nbgrel, igrel, ialiel, nel, itypel
! ----------------------------------------------------------------------
!
!
    call jemarq()
    ligrel = modele(1:8)//'.MODELE'
    nolig = ligrel(1:19)
!
    limped = .true.
!
    call jelira(nolig//'.LIEL', 'NUTIOC', ival=nbgrel)
    repk = 'NON'
    do igrel = 1, nbgrel
        call jeveuo(jexnum(nolig//'.LIEL', igrel), 'L', ialiel)
        call jelira(jexnum(nolig//'.LIEL', igrel), 'LONMAX', ival=nel)
        itypel = zi(ialiel-1+nel)
        call jenuno(jexnum('&CATA.TE.NOMTE', itypel), nomte)
        if ((nomte(1:9).eq.'MEFA_FACE') .or. (nomte(1:6).eq.'MEFASE')) then
            repk = 'OUI'
            exit
        endif
    end do
!
    if (repk .eq. 'NON') then
        limped = .false.
    endif
!
    if (limped) then
        call utmess('I', 'DYNALINE1_23')
    endif
    call jedema()
end subroutine
