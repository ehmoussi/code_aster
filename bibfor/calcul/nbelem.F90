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

function nbelem(ligrlz, igrel, icalc)

use calcul_module, only : ca_illiel_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnum.h"

        character(len=*), intent(in) :: ligrlz
        integer, intent(in) :: igrel
        integer, intent(in), optional :: icalc
        integer :: nbelem
!-----------------------------------------------------------------------
!     Entrees:
!       ligrel (o) : nom d'1 ligrel
!       igrel  (o) : numero d'1 grel
!       icalc  (f) : / 1 :  on est "sous" calcul (et apres appel debca1) 
!                           => on va plus vite
!                    / absent :  => on va moins vite
!     Sorties:
!       nbelem : nombre d'elements du grel igrel
!-----------------------------------------------------------------------
    integer :: n1
    character(len=19) :: ligrel
!-------------------------------------------------------------------
    ligrel=ligrlz
    ASSERT(igrel.gt.0)

!   -- si on est "sous" calcul, on peut aller plus vite :
    if (present(icalc)) then
        ASSERT(icalc.eq.1)
        n1=zi(ca_illiel_-1+igrel+1)-zi(ca_illiel_-1+igrel)
    else
        call jelira(jexnum(ligrel//'.LIEL', igrel), 'LONMAX', n1)
    endif
    nbelem=n1-1

end function
