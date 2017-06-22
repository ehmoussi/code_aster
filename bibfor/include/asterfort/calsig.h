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
    subroutine calsig(fami, kpg, ksp, ein, mod,&
                      rela_comp, vini, x, dtime, epsd,&
                      detot, nmat, coel, sigi)
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        real(kind=8) :: ein(6)
        character(len=8) :: mod
        character(len=16) :: rela_comp
        real(kind=8) :: vini(*)
        real(kind=8) :: x
        real(kind=8) :: dtime
        real(kind=8) :: epsd(6)
        real(kind=8) :: detot(6)
        real(kind=8) :: coel(nmat)
        real(kind=8) :: sigi(6)
    end subroutine calsig
end interface
