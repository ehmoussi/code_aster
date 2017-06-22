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

module lmp_data_module
!
!
! person_in_charge: natacha.bereux at edf.fr
! aslint: disable=W1403
!
use lmp_context_type
!
implicit none
#include "asterf.h"
#include "asterf_types.h"
!
aster_logical :: lmp_is_setup = .false.
type(lmp_ctxt) :: lmp_context
integer, public :: reac_lmp = 15
!
end module lmp_data_module
