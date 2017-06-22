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
    subroutine cabhvf(maxfa, maxdim, ndim, nno, nnos,&
                      nface, axi, geom, vol, mface,&
                      dface, xface, normfa)
        integer :: nno
        integer :: ndim
        integer :: maxdim
        integer :: maxfa
        integer :: nnos
        integer :: nface
        aster_logical :: axi
        real(kind=8) :: geom(1:ndim, 1:nno)
        real(kind=8) :: vol
        real(kind=8) :: mface(1:maxfa)
        real(kind=8) :: dface(1:maxfa)
        real(kind=8) :: xface(1:maxdim, 1:maxfa)
        real(kind=8) :: normfa(1:maxdim, 1:maxfa)
    end subroutine cabhvf
end interface
