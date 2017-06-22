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
    subroutine srdgds(nmat, materf, para, vara, devsig,&
                      i1, val, ds2hds, vecn, dfds,&
                      bprimp, nvi, vint, dhds, tmp, dgds)
        integer :: nvi
        integer :: nmat
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: para(3)
        real(kind=8) :: vara(4)
        real(kind=8) :: devsig(6)
        real(kind=8) :: i1
        integer :: val
        real(kind=8) :: ds2hds(6)
        real(kind=8) :: vecn(6)
        real(kind=8) :: dfds(6)
        real(kind=8) :: bprimp
        real(kind=8) :: vint(nvi)
        real(kind=8) :: dhds(6)
        real(kind=8) :: tmp
        real(kind=8) :: dgds(6, 6)
    end subroutine srdgds
end interface
