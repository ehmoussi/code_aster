! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine varcDetect(mate, l_temp, l_hydr, l_ptot, l_sech, l_epsa, l_meta)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmvcd2.h"
!
character(len=24), intent(in) :: mate
aster_logical, intent(out) :: l_temp, l_hydr, l_ptot
aster_logical, intent(out) :: l_sech, l_epsa, l_meta
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Detection
!
! --------------------------------------------------------------------------------------------------
!
! In  mate             : name of material characteristics (field)
! Out l_temp           : .true. if temperature exists
! Out l_hydr           : .true. if hydratation exists
! Out l_ptot           : .true. if total pressure (THM) exists
! Out l_sech           : .true. if drying exists
! Out l_epsa           : .true. if non-elastic strain exists
! Out l_meta           : .true. if metallurgy exists
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_steel, l_zirc
!
! --------------------------------------------------------------------------------------------------
!
    call nmvcd2('HYDR'   , mate, l_hydr)
    call nmvcd2('PTOT'   , mate, l_ptot)
    call nmvcd2('SECH'   , mate, l_sech)
    call nmvcd2('EPSA'   , mate, l_epsa)
    call nmvcd2('M_ZIRC' , mate, l_zirc)
    call nmvcd2('M_ACIER', mate, l_steel)
    call nmvcd2('TEMP'   , mate, l_temp)
    l_meta = l_temp .and. (l_zirc.or.l_steel)
!
end subroutine
