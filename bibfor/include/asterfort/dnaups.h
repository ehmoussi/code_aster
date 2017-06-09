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
    subroutine dnaups(ido, bmat, n, which, nev,&
                      tol, resid, ncv, v, ldv,&
                      iparam, ipntr, workd, workl, lworkl,&
                      info, neqact, alpha, nsta, ddlsta,&
                      vstab, csta, ldynfa, ddlexc, redem)
        integer :: lworkl
        integer :: ldv
        integer :: ncv
        integer :: n
        integer :: ido
        character(len=1) :: bmat
        character(len=2) :: which
        integer :: nev
        real(kind=8) :: tol
        real(kind=8) :: resid(n)
        real(kind=8) :: v(ldv, ncv)
        integer :: iparam(11)
        integer :: ipntr(14)
        real(kind=8) :: workd(3*n)
        real(kind=8) :: workl(lworkl)
        integer :: info
        integer :: neqact
        real(kind=8) :: alpha
        integer :: nsta
        integer :: ddlsta(n)
        real(kind=8) :: vstab(n)
        real(kind=8) :: csta
        integer :: ldynfa
        integer :: ddlexc(n)
        integer :: redem
    end subroutine dnaups
end interface
