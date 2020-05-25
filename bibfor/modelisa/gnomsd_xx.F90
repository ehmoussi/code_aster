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

subroutine gnomsd_xx(objname)

    implicit none

#include "asterfort/gnomsd.h"

    character(len=24), intent(out) :: objname

! ------------------------------------------------------------------------------
!
! Return a name to be used for a temporary Jeveux object.
! This object will be *temporarly* attached to the DataStructure '00000000'.
!
! Out objname : Object name (24 chars)
!
! ------------------------------------------------------------------------------

    objname = '00000000.TMP123456789012'
    call gnomsd(objname(1:8), objname, 13, 24)

end subroutine
