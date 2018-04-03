! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1504
!
interface
    subroutine lc7058(fami , kpg   , ksp   , ndim  , typmod,&
                      imate, compor, carcri, instam, instap,&
                      neps , epsm  , deps  , nsig  , sigm  ,&
                      nvi  , vim   , option, angmas, icomp ,&
                      sigp , vip   , dsidep, codret)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg, ksp, ndim
        character(len=8), intent(in) :: typmod(*)
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor(*)
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8), intent(in) :: instam, instap
        integer, intent(in) :: neps
        real(kind=8), intent(in) :: epsm(*), deps(*)
        integer, intent(in) :: nsig
        real(kind=8), intent(in) :: sigm(6)
        integer, intent(in) :: nvi
        real(kind=8), intent(in) :: vim(*)
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: angmas(*)
        integer, intent(in) :: icomp     
        real(kind=8), intent(out) :: sigp(6)
        real(kind=8), intent(out) :: vip(nvi)
        real(kind=8), intent(out) :: dsidep(6, 6)
        integer, intent(out) :: codret
    end subroutine lc7058
end interface
