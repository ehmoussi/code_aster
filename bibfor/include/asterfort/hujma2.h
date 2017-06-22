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
    subroutine hujma2(fami, kpg, ksp, mod, imat,&
                      nmat, tempf, angmas, sigd, vind,&
                      materd, materf, ndt, ndi, nvi,&
                      nr, matcst)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: nmat
        character(len=8) :: mod
        integer :: imat
        real(kind=8) :: tempf
        real(kind=8) :: angmas(3)
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(50)
        real(kind=8) :: materd(nmat, 2)
        real(kind=8) :: materf(nmat, 2)
        integer :: ndt
        integer :: ndi
        integer :: nvi
        integer :: nr
        character(len=3) :: matcst
    end subroutine hujma2
end interface
