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
    subroutine elagon(ndim, imate, biot,&
                      alpha, deps, e,&
                      nu, snetm, option, snetp, dsidep,&
                      p1, dp1, dsidp1, dsidp2)
        integer :: ndim
        integer :: imate
        real(kind=8) :: biot
        real(kind=8) :: alpha
        real(kind=8) :: deps(6)
        real(kind=8) :: e
        real(kind=8) :: nu
        real(kind=8) :: snetm(6)
        character(len=16) :: option
        real(kind=8) :: snetp(6)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: p1
        real(kind=8) :: dp1
        real(kind=8) :: dsidp1(6)
        real(kind=8) :: dsidp2(6)
    end subroutine elagon
end interface
