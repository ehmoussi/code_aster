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

subroutine b3d_chrep(m, a, p)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!
!     on calcule la transposée de P => TP
!===================================================================
    implicit none
    real(kind=8) :: m(3, 3), a(3, 3), p(3, 3)
    real(kind=8) :: tp(3, 3), r(3, 3)
    integer :: i, j
#include "asterfort/matmat.h"
    do i = 1, 3
        do j = 1, 3
            tp(i,j)=p(j,i)
            m(i,j)=0.d0
        enddo
    enddo
    call matmat(a, p, 3, 3, 3,&
                r)
    call matmat(tp, r, 3, 3, 3,&
                m)
end subroutine
