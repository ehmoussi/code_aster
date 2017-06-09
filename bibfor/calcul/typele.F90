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

function typele(ligrez, igrel, icalc)
use calcul_module, only : ca_ialiel_, ca_illiel_
implicit none
    integer :: typele

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/assert.h"

    character(len=*), intent(in) :: ligrez
    integer, intent(in) :: igrel
    integer, intent(in), optional :: icalc
!-----------------------------------------------------------------------
!     entrees:
!       ligrel (o) : nom d'1 ligrel
!       igrel  (o) : numero d'1 grel
!       icalc  (f) : / 1 :  on est "sous" calcul => on va plus vite
!                    / None :  => on va moins vite
!
!     sorties:
!       typele : type_element associe au grel
!-----------------------------------------------------------------------
    character(len=19) :: ligrel
    integer :: liel, n1
! ----------------------------------------------------------------------
    ligrel = ligrez

!   -- si on est "sous" calcul, on peut aller plus vite :
    if (present(icalc)) then
        ASSERT(icalc.eq.1)
        n1=zi(ca_illiel_-1+igrel+1)-zi(ca_illiel_-1+igrel)
        typele=zi(ca_ialiel_-1+zi(ca_illiel_-1+igrel)-1+n1)
    else
        call jemarq()
        call jeveuo(jexnum(ligrel//'.LIEL', igrel), 'L', liel)
        call jelira(jexnum(ligrel//'.LIEL', igrel), 'LONMAX', n1)
        typele = zi(liel-1+n1)
        call jedema()
    endif
end function
