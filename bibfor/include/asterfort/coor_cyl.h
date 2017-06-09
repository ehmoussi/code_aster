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
#include "asterf_types.h"
!
interface
    subroutine coor_cyl(ndim, nnop, basloc, geom, ff,&
                        p_g, invp_g, rg, tg, l_not_zero,&
                        courb, dfdi, lcourb)
        integer :: nnop
        integer :: ndim
        real(kind=8) :: ff(*)
        real(kind=8) :: basloc(*)
        real(kind=8) :: geom(*)
        real(kind=8) :: p_g(ndim,ndim)
        real(kind=8) :: invp_g(ndim,ndim)
        real(kind=8) :: rg
        real(kind=8) :: tg
        aster_logical :: l_not_zero
        aster_logical, optional :: lcourb
        real(kind=8), optional :: dfdi(:,:)
        real(kind=8), optional :: courb(3,3,3)
    end subroutine coor_cyl
end interface
