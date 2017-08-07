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
    subroutine xmathm(jmate, thmc, hydr, t, ndim,&
                      nnops, nnop, nddls, nddlm, ffc,&
                      pla, nd, jac, ffp, ffp2, dt, ta, saut,&
                      dffc, rho11, gradpf, mmat,&
                      dsidep, p, r, jheavn, ncompn, ifiss,&
                      nfiss, nfh, ifa, jheafa, ncomph)
                           
        integer :: jmate
        character(len=16) :: thmc
        character(len=16) :: hydr
        real(kind=8) :: t
        integer :: ndim
        integer :: nnops
        integer :: nnop
        integer :: nddls
        integer :: nddlm
        real(kind=8) :: ffc(16)
        integer :: pla(27)
        real(kind=8) :: nd(3)
        real(kind=8) :: jac
        real(kind=8) :: ffp(27)
        real(kind=8) :: ffp2(27)
        real(kind=8) :: dt
        real(kind=8) :: ta
        real(kind=8) :: saut(3)
        real(kind=8) :: dffc(16,3)
        real(kind=8) :: rho11
        real(kind=8) :: gradpf(3)
        real(kind=8) :: mmat(560,560)
        real(kind=8) :: dsidep(6,6)
        real(kind=8) :: p(3,3)
        real(kind=8) :: r
        integer :: jheavn
        integer :: ncompn
        integer :: ifiss
        integer :: nfiss
        integer :: nfh
        integer :: ifa
        integer :: jheafa
        integer :: ncomph
    end subroutine xmathm
end interface
