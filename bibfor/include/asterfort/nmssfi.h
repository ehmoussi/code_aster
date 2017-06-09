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
    subroutine nmssfi(shb6, geom, idfde, ipoids, icoopg, pgl,&
                      ndim, nno, kpg,&
                      rigi,&
                      sigma, matsym, vectu)
        aster_logical, intent(in) :: shb6
        integer, intent(in) :: nno
        real(kind=8), intent(in) :: geom(3,nno)
        integer, intent(in) :: idfde
        integer, intent(in) :: ipoids
        integer, intent(in) :: icoopg
        real(kind=8), intent(in) :: pgl(3,3)
        integer, intent(in) :: ndim
        integer, intent(in) :: kpg
        aster_logical, intent(in) :: rigi
        real(kind=8), intent(in) ::  sigma(6)
        aster_logical, intent(in) :: matsym
        real(kind=8), intent(inout) :: vectu(3,nno)
    end subroutine nmssfi
end interface
