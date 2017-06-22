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
    subroutine lc0001(fami, kpg, ksp, ndim, imate,&
                      neps, deps, nsig, sigm, option,&
                      angmas, sigp, vip, typmod, ndsde,&
                      dsidep, codret)
        integer :: ndsde
        integer :: nsig
        integer :: neps
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: ndim
        integer :: imate
        real(kind=8) :: deps(neps)
        real(kind=8) :: sigm(nsig)
        character(len=16) :: option
        real(kind=8) :: angmas(3)
        real(kind=8) :: sigp(nsig)
        real(kind=8) :: vip(1)
        character(len=8) :: typmod(*)
        real(kind=8) :: dsidep(ndsde)
        integer :: codret
    end subroutine lc0001
end interface
