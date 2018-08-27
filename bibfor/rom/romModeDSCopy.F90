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
subroutine romModeDSCopy(ds_mode_in, ds_mode_out)
!
use Rom_Datastructure_type
!
implicit none
!
type(ROM_DS_Field), intent(in)  :: ds_mode_in
type(ROM_DS_Field), intent(out) :: ds_mode_out
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Copy datastructure of empiric mode
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_mode_in       : datastructure for empiric mode
! Out ds_mode_out      : datastructure for output empiric mode
!
! --------------------------------------------------------------------------------------------------
!
    ds_mode_out%field_name = ds_mode_in%field_name
    ds_mode_out%field_refe = ds_mode_in%field_refe
    ds_mode_out%mesh       = ds_mode_in%mesh
    ds_mode_out%model      = ds_mode_in%model
    ds_mode_out%nb_equa    = ds_mode_in%nb_equa
    ds_mode_out%nb_node    = ds_mode_in%nb_node
!
end subroutine
