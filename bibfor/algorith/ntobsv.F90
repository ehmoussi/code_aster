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

subroutine ntobsv(meshz, sd_obsv, nume_time, time)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/lobs.h"
#include "asterfort/nmobse.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: meshz
    character(len=19), intent(in) :: sd_obsv
    integer, intent(in) :: nume_time
    real(kind=8), intent(in) :: time
!
! --------------------------------------------------------------------------------------------------
!
! THER_* - Observation
!
! Make observation
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  sd_obsv          : datastructure for observation parameters
! In  nume_time        : index of time
! In  time             : current time
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_obsv
!
! --------------------------------------------------------------------------------------------------
!
    l_obsv = .false.
!
! - Observation ?
!
    call lobs(sd_obsv, nume_time, time, l_obsv)
!
! - Make observation 
!
    if (l_obsv) then
        call nmobse(meshz, sd_obsv, time)
    endif
!
end subroutine
