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
!
subroutine nuelrf(elrefe, nujni)
!
implicit  none
!
#include "asterfort/assert.h"
!
character(len=8), intent(in) :: elrefe
integer, intent(out) :: nujni
!
! --------------------------------------------------------------------------------------------------
!
! Finite elements management
!
! Get index of JNI subroutine
!
! --------------------------------------------------------------------------------------------------
!
! In  elrefe           : name of geometric support for finite element
! Out nujni            : index of JNI subroutine
!
! --------------------------------------------------------------------------------------------------
!
    if (elrefe .eq. 'HE8' .or. elrefe .eq. 'H20' .or. elrefe .eq. 'H27' .or.&
        elrefe .eq. 'PE6' .or. elrefe .eq. 'P15' .or. elrefe .eq. 'TE4' .or.&
        elrefe .eq. 'TE9' .or. elrefe .eq. 'TR4' .or.&
        elrefe .eq. 'T10' .or. elrefe .eq. 'PY5' .or. elrefe .eq. 'P13' .or.&
        elrefe .eq. 'QU4' .or. elrefe .eq. 'QU8' .or. elrefe .eq. 'QU9' .or.&
        elrefe .eq. 'TR3' .or. elrefe .eq. 'TR6' .or. elrefe .eq. 'TR7' .or.&
        elrefe .eq. 'SE2' .or. elrefe .eq. 'SE3' .or. elrefe .eq. 'SE4' .or.&
        elrefe .eq. 'PO1' .or. elrefe .eq. 'P18') then
        nujni = 2
    else if (elrefe.eq.'CABPOU') then
        nujni = 92
    else if (elrefe.eq.'THCOSE2') then
        nujni = 91
    else if (elrefe.eq.'THCOSE3') then
        nujni = 91
    else if (elrefe(1:4).eq.'POHO') then
        nujni = 15
    else if (elrefe.eq.'MEC3QU9H') then
        nujni = 80
    else if (elrefe.eq.'MEC3TR7H') then
        nujni = 80
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
