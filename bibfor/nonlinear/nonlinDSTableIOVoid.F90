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
subroutine nonlinDSTableIOVoid(tableio)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
type(NL_DS_TableIO), intent(out) :: tableio
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table in output datastructure management
!
! Create void table
!
! --------------------------------------------------------------------------------------------------
!
! Out tableio          : table in output datastructure
!
! --------------------------------------------------------------------------------------------------
!
    tableio%result       = ' '
    tableio%table_name   = ' '
    tableio%table_type   = ' ' 
    tableio%nb_para      = 0
    tableio%list_para    => null()
    tableio%type_para    => null()
    tableio%nb_para_inte = 0
    tableio%nb_para_real = 0
    tableio%nb_para_cplx = 0
    tableio%nb_para_strg = 0
!
end subroutine
