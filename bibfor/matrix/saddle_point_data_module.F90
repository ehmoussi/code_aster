! --------------------------------------------------------------------
! Copyright (C) 2016 - 2017 - EDF R&D - www.code-aster.org
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

module saddle_point_data_module
!
!
! aslint: disable=W1403
!
use saddle_point_context_type
use augmented_lagrangian_context_type
!
implicit none
!
type(saddlepoint_ctxt), target :: sp_context
type(augm_lagr_ctxt) :: sp_pc_context
!
end module saddle_point_data_module
