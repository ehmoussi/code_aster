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

subroutine CreateTable(result, table)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/ltcrsd.h"
#include "asterfort/exisd.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/tbajpa.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: result
    type(NL_DS_Table), intent(inout) :: table
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table management
!
! Create table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! IO  table            : datastructure for table
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=19) :: table_name
    character(len=24) :: table_type
!
! --------------------------------------------------------------------------------------------------
!
    table_type = table%table_type
!
! - Create list of tables if necessary
!  
    call jeexin(result//'           .LTNT', iret)
    if (iret .eq. 0) then
        call ltcrsd(result, 'G')
    endif
!
! - Get name of table
! 
    call ltnotb(result, table_type, table_name)
!
! - Create table if necessary
!
    call exisd('TABLE', table_name, iret)
    if (iret .eq. 0) then
        call tbcrsd(table_name, 'G')
        call tbajpa(table_name, table%nb_para, table%list_para, table%type_para)
    endif
!
! - Set table parameters
!
    table%result     = result
    table%table_name = table_name
!
end subroutine
