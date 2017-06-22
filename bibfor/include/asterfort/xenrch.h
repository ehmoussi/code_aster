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

!
!
#include "asterf_types.h"
!
interface
    subroutine xenrch(noma, cnslt, cnsln, cnslj,&
                      cnsen, cnsenr, ndim, fiss, goinop,&
                      lismae, lisnoe, operation_opt)
        character(len=8) :: noma
        character(len=19) :: cnslt
        character(len=19) :: cnsln
        character(len=19) :: cnslj
        character(len=19) :: cnsen
        character(len=19) :: cnsenr
        integer :: ndim
        character(len=8) :: fiss
        aster_logical :: goinop
        character(len=24) :: lismae
        character(len=24) :: lisnoe
        character(len=16), intent(in), optional :: operation_opt
    end subroutine xenrch
end interface
