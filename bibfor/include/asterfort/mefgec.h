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
interface
    subroutine mefgec(ndim, nbcyl, som, xint, yint,&
                      rint, dcent, ficent, d, fi)
        integer :: nbcyl
        integer :: ndim(14)
        real(kind=8) :: som(9)
        real(kind=8) :: xint(*)
        real(kind=8) :: yint(*)
        real(kind=8) :: rint(*)
        real(kind=8) :: dcent(*)
        real(kind=8) :: ficent(*)
        real(kind=8) :: d(nbcyl, nbcyl)
        real(kind=8) :: fi(nbcyl, nbcyl)
    end subroutine mefgec
end interface
