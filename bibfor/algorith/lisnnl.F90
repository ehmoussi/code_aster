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

subroutine lisnnl(phenom_, load, obje_pref)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    character(len=*), intent(in) :: phenom_
    character(len=8), intent(in) :: load
    character(len=13), intent(out) :: obje_pref
!
! --------------------------------------------------------------------------------------------------
!
! Loads - Utility
!
! Get prefix of object for a load
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom       : phenomenon (MECANIQUE/THERMIQUE/ACOUSTIQUE)
! In  load         : name of load
! Out obje_pref    : prefix of object
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: phenom
!
! --------------------------------------------------------------------------------------------------
!
    obje_pref = ' '
    phenom    = phenom_
    if (phenom .eq. 'MECANIQUE') then
        obje_pref = load(1:8)//'.CHME'
    else if (phenom.eq.'THERMIQUE') then
        obje_pref = load(1:8)//'.CHTH'
    else if (phenom.eq.'ACOUSTIQUE') then
        obje_pref = load(1:8)//'.CHAC'
    else
        ASSERT(.false.)
    endif
!
end subroutine
