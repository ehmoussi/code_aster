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

subroutine extrai(nin, lchin, lpain, init)

use calcul_module, only : ca_calvoi_, ca_igr_, ca_nbelgr_, ca_nbgr_,&
    ca_ligrel_, ca_nute_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "asterfort/assert.h"
#include "asterfort/extra1.h"
#include "asterfort/nbelem.h"
#include "asterfort/typele.h"

    integer :: nin
    character(len=*) :: lchin(*), init
    character(len=8) :: lpain(*)
!-----------------------------------------------------------------------
!     but: preparer les champs locaux "in"
!-----------------------------------------------------------------------

    ASSERT(init.eq.' '.or.init.eq.'INIT')

    if (ca_calvoi_ .eq. 0) then
        if (init .ne. 'INIT') then
            ca_nute_=typele(ca_ligrel_,ca_igr_)
            call extra1(nin, lchin, lpain)
        endif
    else
!       -- on prepare tout la 1ere fois :
        if (init .eq. 'INIT') then
            do ca_igr_=1,ca_nbgr_
                ca_nbelgr_=nbelem(ca_ligrel_,ca_igr_)
                if (ca_nbelgr_.gt.0) then
                    ca_nute_=typele(ca_ligrel_,ca_igr_)
                    call extra1(nin, lchin, lpain)
                endif
            enddo
        endif
    endif


end subroutine
