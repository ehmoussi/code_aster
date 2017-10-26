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
interface
    subroutine xhmsa6(ndim, ipgf, imate, lamb, wsaut, nd,&
                      tau1, tau2, cohes, job, rela,&
                      alpha, dsidep, sigma, p, am, raug,&
                      wsautm, dpf, rho110)
        integer :: ndim
        integer :: ipgf
        integer :: imate
        real(kind=8) :: lamb(3)
        real(kind=8) :: wsaut(3)
        real(kind=8) :: nd(3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: cohes(5)
        character(len=8) :: job
        real(kind=8) :: rela
        real(kind=8) :: alpha(5)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: sigma(6)
        real(kind=8) :: p(3, 3)
        real(kind=8) :: am(3)
        real(kind=8) :: raug
        real(kind=8) :: wsautm(3)
        real(kind=8) :: dpf
        real(kind=8) :: rho110
    end subroutine xhmsa6
end interface
