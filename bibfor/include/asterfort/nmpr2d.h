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
    subroutine nmpr2d(mode, laxi, nno, npg, poidsg,&
                      vff, dff, geom, p, vect,&
                      matc)
        integer :: npg
        integer :: nno
        integer :: mode
        aster_logical :: laxi
        real(kind=8) :: poidsg(npg)
        real(kind=8) :: vff(nno, npg)
        real(kind=8) :: dff(nno, npg)
        real(kind=8) :: geom(2, nno)
        real(kind=8) :: p(2, npg)
        real(kind=8) :: vect(2, nno)
        real(kind=8) :: matc(2, nno, 2, nno)
    end subroutine nmpr2d
end interface
