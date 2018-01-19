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
subroutine nonlinDSTableVoid(table)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nonlinDSColumnVoid.h"
#include "asterfort/nonlinDSTableIOVoid.h"
!
type(NL_DS_Table), intent(out) :: table
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Table management
!
! Create void table
!
! --------------------------------------------------------------------------------------------------
!
! Out table            : table
!
! --------------------------------------------------------------------------------------------------
!
    type(NL_DS_Column) :: column_void
    type(NL_DS_TableIO) :: tableio_void
    integer :: nb_cols_maxi
!
! --------------------------------------------------------------------------------------------------
!
    call nonlinDSColumnVoid(column_void)
    call nonlinDSTableIOVoid(tableio_void)
    nb_cols_maxi = table%nb_cols_maxi
!
    table%table_io                    = tableio_void
    table%nb_cols                     = 0
    table%cols(1:nb_cols_maxi)        = column_void
    table%l_cols_acti(1:nb_cols_maxi) = ASTER_FALSE
    table%width                       = 0
    table%title_height                = 0
    table%sep_line                    = ' '
    table%l_csv                       = ASTER_FALSE
    table%unit_csv                    = 0
    table%indx_vale(1:nb_cols_maxi)   = 0
!
end subroutine
