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
    subroutine srd2fs(nmat, materf, para, vara, varh,&
                      i1, devsig, ds2hds, d2shds, d2fds2)
        integer :: nmat
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: para(3)
        real(kind=8) :: vara(4)
        real(kind=8) :: varh(2)
        real(kind=8) :: i1
        real(kind=8) :: devsig(6)
        real(kind=8) :: ds2hds(6)
        real(kind=8) :: d2shds(6, 6)
        real(kind=8) :: d2fds2(6, 6)
    end subroutine srd2fs
end interface
