! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine x33x6(x33, x6)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
    implicit none
#include "asterfort/indice0.h"
    real(kind=8) :: x6(6), x33(3, 3)
    integer :: i, k, l
    do i = 1, 6
        call indice0(i, k, l)
        if (i .le. 3) then
            x6(i)=x33(k,l)
        else
            x6(i)=0.5*(x33(k,l)+x33(l,k))
        end if
    end do
end subroutine
