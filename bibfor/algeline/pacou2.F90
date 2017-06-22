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

function pacou2(x, fvec, vecr1, vecr2, typflu,&
                vecr3, amor, masg, vecr4, vecr5,&
                veci1, vg, indic, nbm, nmode,&
                n)
    implicit none
!
! ARGUMENTS
! ---------
#include "jeveux.h"
#include "asterfort/pacouf.h"
    integer :: n
    real(kind=8) :: x(*), fvec(*), amor(*), vg, masg(*)
    real(kind=8) :: vecr1(*), vecr2(*), vecr3(*), vecr4(*), vecr5(*)
    integer :: veci1(*)
    character(len=8) :: typflu
! ----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, indic, nbm, nmode
    real(kind=8) :: pacou2, sum
!-----------------------------------------------------------------------
    call pacouf(x, fvec, vecr1, vecr2, typflu,&
                vecr3, amor, masg, vecr4, vecr5,&
                veci1, vg, indic, nbm, nmode)
    sum = 0.0d0
    do 11 i = 1, n
        sum = sum + fvec(i)*fvec(i)
11  end do
    pacou2 = 0.5d0*sum
!
end function
