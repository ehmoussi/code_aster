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
    subroutine betmat(fami, kpg, ksp, mod, imat,&
                      nmat, tempd, tempf, materd, materf,&
                      matcst, ndt, ndi, nr, nvi)
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=8) :: mod
        integer :: imat
        real(kind=8) :: tempd
        real(kind=8) :: tempf
        real(kind=8) :: materd(nmat, 2)
        real(kind=8) :: materf(nmat, 2)
        character(len=3) :: matcst
        integer :: ndt
        integer :: ndi
        integer :: nr
        integer :: nvi
    end subroutine betmat
end interface
