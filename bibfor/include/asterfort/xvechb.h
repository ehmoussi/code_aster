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
    subroutine xvechb(nnops, ddls, ddlm, ndim,&
                      ffp2, q1, dt, ta, jac, q1m, ta1,&
                      q2, q2m, vect, ncompn, jheavn, ifiss,&
                      nfiss, nfh, ifa, jheafa, ncomph)
                           
        integer :: ndim
        integer :: ddls
        integer :: ddlm
        integer :: nnops
        real(kind=8) :: ffp2(27)
        real(kind=8) :: q1
        real(kind=8) :: q1m
        real(kind=8) :: q2
        real(kind=8) :: q2m
        real(kind=8) :: dt
        real(kind=8) :: ta
        real(kind=8) :: jac
        real(kind=8) :: ta1
        real(kind=8) :: vect(560)
        integer :: ncompn
        integer :: jheavn
        integer :: ifiss
        integer :: nfiss
        integer :: nfh
        integer :: ifa
        integer :: jheafa
        integer :: ncomph
    end subroutine xvechb
end interface
