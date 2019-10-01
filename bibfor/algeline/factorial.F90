! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
function factorial(n)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: n
    integer             :: factorial
!
! --------------------------------------------------------------------------------------------------
!
! Linear algebra
!
! Compute factorial function
!
! --------------------------------------------------------------------------------------------------
!
!   In n : factorial of n
!
! --------------------------------------------------------------------------------------------------
!
    select case (n)
        case (0)
            factorial = 1
        case (1)
            factorial = 1
        case (2)
            factorial = 2
        case (3)
            factorial = 6
        case (4)
            factorial = 24
        case (5)
            factorial = 120
        case (6)
            factorial = 720
        case (7)
            factorial = 5040
        case (8)
            factorial = 40320
        case (9)
            factorial = 362880
        case (10)
            factorial = 3628800
        case (11)
            factorial = 39916800
!        case (12)
!            factorial = 479001600
!        case (13)
!            factorial = 6227020800
!        case (14)
!            factorial = 87178291200
!        case (15)
!            factorial = 1307674368000
!        case (16)
!            factorial = 20922789888000
!        case (17)
!            factorial = 355687428096000
!        case (18)
!            factorial = 6402373705728000
!        case (19)
!            factorial = 121645100408832000
!        case (20)
!            factorial = 2432902008176640000
        case default
            ASSERT(ASTER_FALSE)
        end select
!
end function
