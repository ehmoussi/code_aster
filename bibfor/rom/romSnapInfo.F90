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

subroutine romSnapInfo(ds_snap)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Snap), intent(in) :: ds_snap
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Informations about snapshot selection
!
! --------------------------------------------------------------------------------------------------
! 
! In  ds_snap          : datastructure for snapshot selection
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_snap = 0
!
! --------------------------------------------------------------------------------------------------
!
    nb_snap = ds_snap%nb_snap
!
! - Print
!
    call utmess('I','ROM2_9', si = nb_snap)
!
end subroutine
