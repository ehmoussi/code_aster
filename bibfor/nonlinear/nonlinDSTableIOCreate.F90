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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nonlinDSTableIOCreate(result, table_typez, tableio)
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
character(len=8), intent(in) :: result
character(len=*), intent(in) :: table_typez
type(NL_DS_TableIO), intent(inout) :: tableio
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table in output datastructure management
!
! Create table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  table_type       : type of table
! IO  tableio          : table in output datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=19) :: table_name
    character(len=24) :: table_type
!
! --------------------------------------------------------------------------------------------------
!
    table_name = ' '
    table_type = table_typez
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
        call tbajpa(table_name, tableio%nb_para, tableio%list_para, tableio%type_para)
    endif
!
! - Set table parameters
!
    tableio%result     = result
    tableio%table_name = table_name
    tableio%table_type = table_type
!
end subroutine
