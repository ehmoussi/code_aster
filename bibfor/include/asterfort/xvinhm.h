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
    subroutine xvinhm(jmate, thmc, meca, hydr, ndim,&
                      cohes, dpf, saut, sautm, nd, lamb,&
                      w11m, rho11m, alpha, job, t, pf,&
                      rho11, w11, ipgf, rela, dsidep,&
                      delta, r, am)
                           
        integer :: jmate
        character(len=16) :: thmc
        character(len=16) :: meca
        character(len=16) :: hydr
        integer :: ndim
        real(kind=8) :: cohes(5)
        real(kind=8) :: dpf
        real(kind=8) :: saut(3)
        real(kind=8) :: sautm(3)
        real(kind=8) :: nd(3)
        real(kind=8) :: lamb(3)
        real(kind=8) :: w11m
        real(kind=8) :: rho11m
        real(kind=8) :: alpha(5)
        character(len=8) :: job
        real(kind=8) :: t
        real(kind=8) :: pf
        real(kind=8) :: rho11
        real(kind=8) :: w11
        integer :: ipgf
        real(kind=8) :: rela
        real(kind=8) :: dsidep(6,6)
        real(kind=8) :: delta(6)
        real(kind=8) :: r
        real(kind=8) :: am(3)
    end subroutine xvinhm
end interface
