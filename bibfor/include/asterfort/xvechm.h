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
! aslint: disable=W1504
!
interface
    subroutine xvechm(nnops, ddls, ddlm, ndim, pla,&
                      saut, sautm, nd, ffc, w11, w11m, jac,&
                      q1, dt, ta, q1m, ta1, q2, q2m, dffc,&
                      rho11, gradpf, rho11m, gradpfm, ffp2,&
                      vect, ffp,&
                      nnop, delta, lamb, am, r, p, psup,&
                      pinf, pf, ncompn, jheavn, ifiss, nfiss,&
                      nfh, ifa, jheafa, ncomph)
                           
        integer :: nnops
        integer :: nnop
        integer :: ddls
        integer :: ddlm
        integer :: ndim
        integer :: pla(27)
        real(kind=8) :: saut(3)
        real(kind=8) :: sautm(3)
        real(kind=8) :: nd(3)
        real(kind=8) :: ffc(16)
        real(kind=8) :: w11
        real(kind=8) :: w11m
        real(kind=8) :: jac
        real(kind=8) :: q1
        real(kind=8) :: dt
        real(kind=8) :: ta
        real(kind=8) :: q1m
        real(kind=8) :: ta1
        real(kind=8) :: q2
        real(kind=8) :: q2m
        real(kind=8) :: dffc(16,3)
        real(kind=8) :: rho11
        real(kind=8) :: gradpf(3)
        real(kind=8) :: rho11m
        real(kind=8) :: gradpfm(3)
        real(kind=8) :: ffp2(27)
        real(kind=8) :: vect(560)
        real(kind=8) :: ffp(27)
        real(kind=8) :: delta(6)
        real(kind=8) :: lamb(3)
        real(kind=8) :: am(3)
        real(kind=8) :: r
        real(kind=8) :: p(3,3)
        real(kind=8) :: psup
        real(kind=8) :: pinf
        real(kind=8) :: pf
        integer :: ncompn
        integer :: jheavn
        integer :: nfiss
        integer :: ifiss
        integer :: nfh
        integer :: ifa
        integer :: jheafa
        integer :: ncomph
    end subroutine xvechm
end interface
