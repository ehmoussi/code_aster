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

subroutine IncrEnergy(ds_energy, energy_type_, vale_r)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Energy), intent(inout) :: ds_energy
    character(len=*), intent(in) :: energy_type_
    real(kind=8), intent(in) :: vale_r
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Energy management
!
! Add energy
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_energy        : datastructure for energy management
! In  type_energy      : type of energy
! In  vale_r           : value of energy to increment - Out: current value
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cols, i_col, indx_col
    character(len=24) :: energy_type
    type(NL_DS_Table) :: table
!
! --------------------------------------------------------------------------------------------------
!
    energy_type = energy_type_
!
! - Get table
!
    table   = ds_energy%table
    nb_cols = table%nb_cols
!
! - Get column
!
    indx_col = 0
    do i_col = 1, nb_cols
        if (table%cols(i_col)%name .eq. energy_type) then
            ASSERT(indx_col .eq. 0)
            indx_col = i_col
        endif
    end do
    ASSERT(indx_col .ne. 0)
!
! - Add energy
!
    ASSERT(table%cols(indx_col)%l_vale_real)
    table%cols(indx_col)%vale_real = table%cols(indx_col)%vale_real + vale_r
!
! - Set table
!
    ds_energy%table = table
!
end subroutine
