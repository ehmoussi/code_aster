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
    subroutine forcdy(masse, amort, lamort, neq, c0,&
                      c1, c2, c3, c4, c5,&
                      d0, v0, a0, f1, f2,&
                      f)
        integer :: masse
        integer :: amort
        aster_logical :: lamort
        integer :: neq
        real(kind=8) :: c0
        real(kind=8) :: c1
        real(kind=8) :: c2
        real(kind=8) :: c3
        real(kind=8) :: c4
        real(kind=8) :: c5
        real(kind=8) :: d0(*)
        real(kind=8) :: v0(*)
        real(kind=8) :: a0(*)
        real(kind=8) :: f1(*)
        real(kind=8) :: f2(*)
        real(kind=8) :: f(*)
    end subroutine forcdy
end interface
