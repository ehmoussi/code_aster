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

subroutine ibcatc(type, iunit, ier)
    implicit none
#include "asterfort/ibcael.h"
#include "asterfort/inccat.h"
#include "asterfort/lccata.h"
    character(len=*) :: type
    integer :: iunit, ier
! MAIN DE LA LECTURE DES CATALOGUE
!     -----------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (type .eq. 'CATAELEM') then
        call inccat()
        call lccata(iunit)
    else if (type .eq. 'ELEMBASE') then
        call ibcael('LIRE')
    endif
!
    ier=0
end subroutine
