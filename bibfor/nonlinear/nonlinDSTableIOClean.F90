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
! aslint: disable=W1403
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nonlinDSTableIOClean(tableio)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
!
type(NL_DS_TableIO), intent(inout) :: tableio
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table in output datastructure management
!
! Clean table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! IO  tableio          : table in output datastructure
!
! --------------------------------------------------------------------------------------------------
!
    AS_DEALLOCATE(vk24 = tableio%list_para)
    AS_DEALLOCATE(vk8 = tableio%type_para)
!
end subroutine
