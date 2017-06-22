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
    subroutine xhvco4(ino, ndim, sigma, lamb, pla,&
                      jac, ffc, p, raug, vect)
        integer :: ino
        integer :: ndim
        real(kind=8) :: sigma(6)
        real(kind=8) :: lamb(3)
        integer :: pla(27)
        real(kind=8) :: jac
        real(kind=8) :: ffc(16)
        real(kind=8) :: ffp(27)
        real(kind=8) :: p(3,3)
        real(kind=8) :: raug
        real(kind=8) :: vect(560)
    end subroutine xhvco4
end interface
