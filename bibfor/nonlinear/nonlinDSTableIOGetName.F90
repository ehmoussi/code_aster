! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nonlinDSTableIOGetName(tableio)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jeexin.h"
#include "asterfort/ltcrsd.h"
#include "asterfort/ltnotb.h"
!
type(NL_DS_TableIO), intent(inout) :: tableio
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table in output datastructure management
!
! Get name of table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! IO  tableio          : table in output datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=8) :: resultName
    character(len=24) :: tablName
    character(len=16) :: tablSymbName
!
! --------------------------------------------------------------------------------------------------
!
    tablName     = ' '
    resultName   = tableio%resultName
    tablSymbName = tableio%tablSymbName
!
! - Get list of tables
!  
    call jeexin(resultName//'           .LTNT', iret)
    if (iret .eq. 0) then
        call ltcrsd(resultName, 'G')
    endif
!
! - Get name of table in results datastructure
!
    call ltnotb(resultName, tablSymbName, tablName)
!
! - Set table parameters
!
    tableio%tablName = tablName
!
end subroutine
