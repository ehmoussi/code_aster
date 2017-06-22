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

subroutine exipat(mesh, iret)
!
implicit none
!
#include "asterfort/jeexin.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: mesh
    integer, intent(out) :: iret
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Check if exist PATCH in mesh
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! Out iret             : 1 if PATCH exists in mesh 0 otherwise
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ipatch
!
! --------------------------------------------------------------------------------------------------
!
    iret = 0
    call jeexin(mesh//'.PATCH', ipatch)
    if (ipatch .ne. 0) then
        iret=1
    endif
!
end subroutine
