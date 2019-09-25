! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
subroutine te0450(nomopt, nomte)
!
use HHO_type
use HHO_statcond_module, only : hhoDecondStaticMeca
use HHO_init_module, only : hhoInfoInitCell
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! --------------------------------------------------------------------------------------------------
!  HHO
!  Static decondensation for mecanic
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: nomte, nomopt
!
! --- Local variables
!
    type(HHO_Data) :: hhoData
    type(HHO_Cell) :: hhoCell
! --------------------------------------------------------------------------------------------------
!
! --- Retrieve HHO informations
!
    call hhoInfoInitCell(hhoCell, hhoData, l_ortho_ = ASTER_FALSE)
!
    if (nomopt == 'HHO_DECOND_MECA') then
        call hhoDecondStaticMeca(hhoCell, hhoData)
    else
        ASSERT(ASTER_FALSE)
    end if
!
end subroutine
