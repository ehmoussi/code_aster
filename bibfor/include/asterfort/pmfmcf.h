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
    subroutine pmfmcf(ip, nbgf, nbfib, nugf, sdcomp,&
                      crit, option, instam, instap,&
                      icdmat, nbvalc, defam, defap, varim,&
                      varimp, contm, defm, defp, epsm,&
                      modf, sigf, varip, codret)
        integer :: ip
        integer :: nbgf
        integer :: nbfib
        integer :: nugf(*)
        character(len=24) :: sdcomp(*)
        real(kind=8) :: crit(*)
        character(len=16) :: option
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: icdmat
        integer :: nbvalc
        real(kind=8) :: defam(*)
        real(kind=8) :: defap(*)
        real(kind=8) :: varim(*)
        real(kind=8) :: varimp(*)
        real(kind=8) :: contm(*)
        real(kind=8) :: defm(*)
        real(kind=8) :: defp(*)
        real(kind=8) :: epsm
        real(kind=8) :: modf(*)
        real(kind=8) :: sigf(*)
        real(kind=8) :: varip(*)
        integer :: codret
    end subroutine pmfmcf
end interface
