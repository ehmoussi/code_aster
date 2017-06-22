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
    subroutine intfac(noma, nmaabs, ifq, fa, nno,&
                      lst, lsn, ndim, grad, jglsn,&
                      jglst, igeom, m, indptf, gln,&
                      glt, codret)
        integer :: ndim
        integer :: nno
        character(len=8) :: noma
        integer :: nmaabs
        integer :: ifq
        integer :: fa(6, 8)
        real(kind=8) :: lst(nno)
        real(kind=8) :: lsn(nno)
        character(len=3) :: grad
        integer :: jglsn
        integer :: jglst
        integer :: igeom
        real(kind=8) :: m(ndim)
        integer :: indptf(3)
        real(kind=8) :: gln(ndim)
        real(kind=8) :: glt(ndim)
        integer :: codret
    end subroutine intfac
end interface
