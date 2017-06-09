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
    subroutine lc7058(fami, kpg, ksp, ndim, typmod,&
                      imate, compor, crit, instam, instap,&
                      neps, epsm, deps, nsig, sigm,&
                      nvi, vim, option, angmas, &
                      icomp, stress, statev, dsidep,&
                      codret)
        integer :: nvi
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: ndim
        character(len=8) :: typmod(*)
        integer :: imate
        character(len=16) :: compor(*)
        real(kind=8) :: crit(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: neps
        real(kind=8) :: epsm(6)
        real(kind=8) :: deps(6)
        integer :: nsig
        real(kind=8) :: sigm(6)
        real(kind=8) :: vim(*)
        character(len=16) :: option
        real(kind=8) :: angmas(*)
        integer :: icomp
        real(kind=8) :: stress(6)
        real(kind=8) :: statev(nvi)
        real(kind=8) :: dsidep(6, 6)
        integer :: codret
    end subroutine lc7058
end interface
