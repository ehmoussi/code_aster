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

subroutine multsy(u22, a3, v22, msym)
!
    implicit  none
!
#include "asterfort/matmul.h"
    real(kind=8) :: msym(*)
!
    real(kind=8) :: u22(2, *), v22(2, *), a3(*), a22(2, 2), msym22(2, 2)
!
    real(kind=8) :: cp(2, 2)
! Construction of the symetric matrix A
    a22(1,1) = a3(1)
    a22(2,2) = a3(2)
    a22(1,2) = a3(3)
    a22(2,1) = a3(3)
!
! Multiplication: MSYM = U22 * A * V22
    call matmul(a22, v22, 2, 2, 2,&
                cp)
    call matmul(u22, cp, 2, 2, 2,&
                msym22)
! Construction of the rank-one result matrix
    msym(1) = msym22(1,1)
    msym(2) = msym22(2,2)
    msym(3) = msym22(1,2)
!
end subroutine
