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
    subroutine xadher(p, saut, lamb1, cstafr, cpenfr,&
                      algofr, vitang, pboul, kn, ptknp,&
                      ik, adher)
        real(kind=8) :: p(3, 3)
        real(kind=8) :: saut(3)
        real(kind=8) :: lamb1(3)
        real(kind=8) :: cstafr
        real(kind=8) :: cpenfr
        integer :: algofr
        real(kind=8) :: vitang(3)
        real(kind=8) :: pboul(3)
        real(kind=8) :: kn(3, 3)
        real(kind=8) :: ptknp(3, 3)
        real(kind=8) :: ik(3, 3)
        aster_logical :: adher
    end subroutine xadher
end interface
