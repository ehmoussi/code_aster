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
    subroutine lc0059(fami, kpg, ksp, imate,&
                      compor, carcri, instam, instap, neps, epsm,&
                      deps, nsig, sigm, nvi, vim, option, angmas,&
                      sigp, vip,&
                      typmod, icomp, dsidep, codret)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor(*)
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8), intent(in) :: instam
        real(kind=8), intent(in) :: instap
        integer, intent(in) :: neps
        integer, intent(in) :: nsig
        integer, intent(in) :: nvi
        real(kind=8), intent(in) :: epsm(neps)
        real(kind=8), intent(in) :: deps(neps)
        real(kind=8), intent(in) :: sigm(nsig)
        real(kind=8), intent(in) :: vim(nvi)
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: angmas(3)
        real(kind=8), intent(out) :: sigp(nsig)
        real(kind=8), intent(out) :: vip(nvi)
        character(len=8), intent(in) :: typmod(*)
        integer, intent(in) :: icomp

        real(kind=8), intent(out) :: dsidep(6, 6)
        integer, intent(out) :: codret
    end subroutine lc0059
end interface
