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
    subroutine nmccam(fami, kpg, ksp, ndim, typmod, imate, compor, carcri,&
                      deps, sigm, pcrm, option, sigp,&
                      pcrp, dsidep, retcom)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer :: ndim
        character(len=8) :: typmod(*)
        integer :: imate
        character(len=16) :: compor(*)
        real(kind=8) :: carcri(3)
        real(kind=8) :: deps(6)
        real(kind=8) :: sigm(6)
        real(kind=8) :: pcrm(7)
        character(len=16) :: option
        real(kind=8) :: sigp(6)
        real(kind=8) :: pcrp(7)
        real(kind=8) :: dsidep(6, 6)
        integer :: retcom
    end subroutine nmccam
end interface
