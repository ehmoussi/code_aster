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
    subroutine forcen(rnormc, intsn, nb1, xi, xr,&
                      rho, epais, vomega, vecl1, xa)
        real(kind=8) :: rnormc
        integer :: intsn
        integer :: nb1
        real(kind=8) :: xi(3, *)
        real(kind=8) :: xr(*)
        real(kind=8) :: rho
        real(kind=8) :: epais
        real(kind=8) :: vomega(3)
        real(kind=8) :: vecl1(42)
        real(kind=8) :: xa(3)
    end subroutine forcen
end interface
