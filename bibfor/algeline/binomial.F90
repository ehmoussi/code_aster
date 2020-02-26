! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
function binomial(n, k)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/factorial.h"
!
!
    integer, intent(in) :: n, k
    integer             :: binomial
!
! --------------------------------------------------------------------------------------------------
!
! Linear algebra
!
! Compute binomial coefficient
!
! --------------------------------------------------------------------------------------------------
!
!   In n, k : k parmi n
!
! --------------------------------------------------------------------------------------------------
!
    integer, dimension(20) :: coeff
!
!
    ASSERT(k .lt. n)
!
    coeff(:) = 0
    binomial = 0
    if(k < 0) then
        binomial = 0
    else if(k == 0) then
            binomial = 1
    else
        select case (n)
            case (1)
                coeff(1) = 1
                binomial = coeff(k)
            case (2)
                coeff(1:2) = (/2, 1/)
                binomial = coeff(k)
            case (3)
                coeff(1:3) = (/3, 3, 1/)
                binomial = coeff(k)
            case (4)
                coeff(1:4) = (/4, 6, 4, 1 /)
                binomial = coeff(k)
            case (5)
                coeff(1:5) = (/5, 10, 10, 5, 1/)
                binomial = coeff(k)
            case (6)
                coeff(1:6) = (/6, 15, 20, 15, 6, 1/)
                binomial = coeff(k)
            case (7)
                coeff(1:7) = (/7, 21, 35, 35, 21, 7, 1/)
                binomial = coeff(k)
            case (8)
                coeff(1:8) = (/8, 28, 56, 70, 56, 28, 8, 1/)
                binomial = coeff(k)
            case (9)
                coeff(1:9) = (/9, 36, 84, 126, 126, 84, 36, 9, 1/)
                binomial = coeff(k)
            case (10)
                coeff(1:10) = (/10, 45, 120, 210, 252, 210, 120, 45, 10, 1/)
                binomial = coeff(k)
            case (11)
                    coeff(1:11) = (/11, 55, 165, 330, 462, 462, 330, 165, 55, 11, 1/)
                binomial = coeff(k)
            case (12)
                    coeff(1:12) = (/12, 66, 220, 495, 792, 924, 792, 495, 220, 66, 12, 1/)
                binomial = coeff(k)
            case (13)
                    coeff(1:13) = (/13, 78, 286, 715, 1287, 1716, 1716, 1287, 715, 286, 78, 13, 1/)
                binomial = coeff(k)
            case (14)
                coeff(1:14) = (/14, 91, 364, 1001, 2002, 3003, 3432, 3003, 2002, 1001, 364, &
                                &  91, 14, 1/)
                binomial = coeff(k)
            case (15)
                coeff(1:15) = (/15, 105, 455, 1365, 3003, 5005, 6435, 6435, 5005, 3003, 1365,&
                                &  455, 105, 15, 1/)
                binomial = coeff(k)
            case (16)
                coeff(1:16) = (/16, 120, 560, 1820, 4368, 8008, 11440, 12870, 11440, 8008, &
                            &  4368, 1820, 560, 120, 16, 1/)
                binomial = coeff(k)
            case (17)
                coeff(1:17) = (/17, 136, 680, 2380, 6188, 12376, 19448, 24310, 24310, 19448, &
                                & 12376, 6188, 2380, 680, 136, 17, 1/)
                binomial = coeff(k)
            case (18)
                coeff(1:18) = (/18, 153, 816, 3060, 8568, 18564, 31824, 43758, 48620, 43758, &
                                & 31824, 18564, 8568, 3060, 816, 153, 18, 1/)
                binomial = coeff(k)
            case (19)
                coeff(1:19) = (/19, 171, 969, 3876, 11628, 27132, 50388, 75582, 92378, 92378,&
                                & 75582, 50388, 27132, 11628, 3876, 969, 171, 19, 1/)
                 binomial = coeff(k)
            case (20)
                coeff(1:20) = (/20, 190, 1140, 4845, 15504, 38760, 77520, 125970, 167960, &
                                & 184756, 167960, 125970, 77520, 38760, 15504, 4845, 1140, 190, 20,&
                                & 1 /)
                 binomial = coeff(k)
            case default
                    binomial = factorial(n)/(factorial(n-k) * factorial(k))
            end select
        end if
!
end function
