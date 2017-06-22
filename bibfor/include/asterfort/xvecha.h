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
    subroutine xvecha(ndim, pla, nnops, saut,&
                      sautm, nd, ffc, w11, w11m, jac,&
                      q1, q1m, q2, q2m, dt, ta, ta1,&
                      dffc, rho11, mu, gradpf, rho11m,&
                      gradpfm, vect)
                           
        integer :: ndim
        integer :: pla(27)
        integer :: nnops
        real(kind=8) :: saut(3)
        real(kind=8) :: sautm(3)
        real(kind=8) :: nd(3)
        real(kind=8) :: ffc(16)
        real(kind=8) :: w11
        real(kind=8) :: w11m
        real(kind=8) :: jac
        real(kind=8) :: q1
        real(kind=8) :: q1m
        real(kind=8) :: q2
        real(kind=8) :: q2m
        real(kind=8) :: dt
        real(kind=8) :: ta
        real(kind=8) :: ta1
        real(kind=8) :: dffc(16,3)
        real(kind=8) :: rho11
        real(kind=8) :: mu
        real(kind=8) :: gradpf(3)
        real(kind=8) :: rho11m
        real(kind=8) :: gradpfm(3)
        real(kind=8) :: vect(560)
    end subroutine xvecha
end interface
