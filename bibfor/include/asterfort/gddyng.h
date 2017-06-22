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
    subroutine gddyng(kp, nno, en, x0sk, rmkm1,&
                      rmk, omkm1, ompkm1, omk, ompk,&
                      x0sec, rgmkm, rgmk, omgkm, ompgkm,&
                      omgk, ompgk)
        integer :: kp
        integer :: nno
        real(kind=8) :: en(3, 2)
        real(kind=8) :: x0sk(3, 3)
        real(kind=8) :: rmkm1(3, 3)
        real(kind=8) :: rmk(3, 3)
        real(kind=8) :: omkm1(3, 3)
        real(kind=8) :: ompkm1(3, 3)
        real(kind=8) :: omk(3, 3)
        real(kind=8) :: ompk(3, 3)
        real(kind=8) :: x0sec(3)
        real(kind=8) :: rgmkm(3)
        real(kind=8) :: rgmk(3)
        real(kind=8) :: omgkm(3)
        real(kind=8) :: ompgkm(3)
        real(kind=8) :: omgk(3)
        real(kind=8) :: ompgk(3)
    end subroutine gddyng
end interface
