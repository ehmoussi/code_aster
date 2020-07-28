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
subroutine nonlinDSTableIOCreate(tableio)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/exisd.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/tbajpa.h"
!
type(NL_DS_TableIO), intent(in) :: tableio
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table in output datastructure management
!
! Create table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  tableio          : table in output datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=8) :: resultName
    character(len=24) :: tablName
!
! --------------------------------------------------------------------------------------------------
!
    tablName   = tableio%tablName
    resultName = tableio%resultName
!
! - Access to list of tables
!  
    call jeexin(resultName//'           .LTNT', iret)
    ASSERT(iret .gt. 0)
!
! - Create table if necessary
!
    call exisd('TABLE', tablName, iret)
    if (iret .eq. 0) then
        call tbcrsd(tablName, 'G')
        call tbajpa(tablName, tableio%nbPara, tableio%paraName, tableio%paraType)
    endif
!
end subroutine
