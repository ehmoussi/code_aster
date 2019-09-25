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
subroutine te0456(nomopt, nomte)
!
use HHO_type
use HHO_postpro_module, only : hhoPostMeca
use HHO_init_module, only : hhoInfoInitCell
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
!
! --------------------------------------------------------------------------------------------------
!  HHO
!  Post-Processing for mecanic
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: nomte, nomopt
!
! --- Local variables
!
    type(HHO_Data) :: hhoData
    type(HHO_Cell) :: hhoCell
    integer :: nbnodes
! --------------------------------------------------------------------------------------------------
!
! --- Retrieve HHO informations
!
    call hhoInfoInitCell(hhoCell, hhoData)
!
    call elrefe_info(fami='RIGI', nno=nbnodes)
!
    if (nomopt == 'HHO_DEPL_MECA') then
! --- post-traitement
        call hhoPostMeca(hhoCell, hhoData, nbnodes)
    else
        ASSERT(ASTER_FALSE)
    end if
!
end subroutine
