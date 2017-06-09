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
    subroutine e1e2nn(nno, dfde, dfdk, e1n, e2n,&
                      nxn, nyn, nzn, normn, j1n,&
                      j2n, san, can)
        integer :: nno
        real(kind=8) :: dfde(9, 9)
        real(kind=8) :: dfdk(9, 9)
        real(kind=8) :: e1n(3, 9)
        real(kind=8) :: e2n(3, 9)
        real(kind=8) :: nxn(9)
        real(kind=8) :: nyn(9)
        real(kind=8) :: nzn(9)
        real(kind=8) :: normn(3, 9)
        real(kind=8) :: j1n(9)
        real(kind=8) :: j2n(9)
        real(kind=8) :: san(9)
        real(kind=8) :: can(9)
    end subroutine e1e2nn
end interface
