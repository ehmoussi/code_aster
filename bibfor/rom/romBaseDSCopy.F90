! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine romBaseDSCopy(ds_empi_in, base, ds_empi_out)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/romBaseDSInit.h"
!
type(ROM_DS_Empi), intent(in)  :: ds_empi_in
character(len=8), intent(in)   :: base
type(ROM_DS_Empi), intent(out) :: ds_empi_out
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Copy datastructure of empiric modes base
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi_in       : datastructure for empiric modes
! In  base             : name of output empiric base
! Out ds_empi_out      : datastructure for output empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    call romBaseDSInit(ds_empi_in%ds_lineic, ds_empi_out)
!
! - Copy informations
!
    ds_empi_out%base       = ds_empi_in%base
    ds_empi_out%field_name = ds_empi_in%field_name
    ds_empi_out%field_refe = ds_empi_in%field_refe
    ds_empi_out%mesh       = ds_empi_in%mesh
    ds_empi_out%model      = ds_empi_in%model
    ds_empi_out%base_type  = ds_empi_in%base_type
    ds_empi_out%axe_line   = ds_empi_in%axe_line
    ds_empi_out%surf_num   = ds_empi_in%surf_num
    ds_empi_out%nb_equa    = ds_empi_in%nb_equa
    ds_empi_out%nb_node    = ds_empi_in%nb_node
    ds_empi_out%nb_mode    = ds_empi_in%nb_mode
!
! - Change base
!
    ds_empi_out%base       = base
!
end subroutine
