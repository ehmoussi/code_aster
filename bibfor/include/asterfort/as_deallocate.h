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

!
! because macros must be on a single line
! aslint: disable=C1509
!
#include "asterf.h"
#include "asterf_debug.h"

#ifdef __DEBUG_ALLOCATE__
#   define DEBUG_LOC_DEALLOCATE(a, b, c) DEBUG_LOC(a, b, c)
#else
#   define DEBUG_LOC_DEALLOCATE(a, b, c) continue
#endif

! To have a syntax similar to the standard DEALLOCATE
#define AS_DEALLOCATE(arg) DEBUG_LOC_DEALLOCATE("free ", __FILE__, __LINE__) ; call as_deallocate(arg, strdbg=TO_STRING(arg))
!
#include "asterf_types.h"
!
interface
    subroutine as_deallocate(vl, vi, vi4, vr, vc, &
                             vk8, vk16, vk24, vk32, vk80, &
                             strdbg)
    aster_logical,           optional, pointer :: vl(:)
    integer,           optional, pointer :: vi(:)
    integer(kind=4),   optional, pointer :: vi4(:)
    real(kind=8),      optional, pointer :: vr(:)
    complex(kind=8),   optional, pointer :: vc(:)
    character(len=8),  optional, pointer :: vk8(:)
    character(len=16), optional, pointer :: vk16(:)
    character(len=24), optional, pointer :: vk24(:)
    character(len=32), optional, pointer :: vk32(:)
    character(len=80), optional, pointer :: vk80(:)
!
        character(len=*) :: strdbg
    end subroutine as_deallocate
end interface
