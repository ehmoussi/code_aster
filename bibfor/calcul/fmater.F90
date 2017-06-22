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

subroutine fmater(nbfmax, nftab, tab)

use calcul_module, only : ca_jfpgl_, ca_nfpg_
implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterfort/assert.h"

    integer :: nbfmax, nftab
    character(len=8) :: tab(*)
!-----------------------------------------------------------------------
! but : recuperer les familles de points de gauss de la liste MATER
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------

    ASSERT(nbfmax .ge. ca_nfpg_)
    nftab=ca_nfpg_
    do i=1, ca_nfpg_
        tab(i)=zk8(ca_jfpgl_+i-1)
    end do

end subroutine
