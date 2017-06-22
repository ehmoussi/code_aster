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
    subroutine nmgeog(ndim, nno, axi, grand, geom,&
                      kpg, ivf, depl,&
                      ldfdi, poids, dfdi, f, eps,&
                      r)
        integer :: ndim
        integer :: nno
        aster_logical :: axi
        aster_logical :: grand
        real(kind=8) :: geom(ndim, nno)
        integer :: kpg
        integer :: ivf
        real(kind=8) :: depl(ndim, nno)
        aster_logical :: ldfdi
        real(kind=8) :: poids
        real(kind=8) :: dfdi(nno, ndim)
        real(kind=8) :: f(3, 3)
        real(kind=8) :: eps(6)
        real(kind=8) :: r
    end subroutine nmgeog
end interface
