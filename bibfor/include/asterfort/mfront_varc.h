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

interface
    subroutine  mfront_varc(fami   , kpg      , ksp, imate, &
                            nb_varc, list_varc, &
                            temp   , dtemp    , &
                            predef , dpred    , &
                            neps   , epsth    , depsth)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer, intent(in) :: imate
        integer, intent(in) :: nb_varc
        character(len=8), intent(in) :: list_varc(*)
        real(kind=8), intent(out) :: temp, dtemp
        real(kind=8), intent(out) :: predef(*), dpred(*)
        integer, intent(in) :: neps
        real(kind=8), intent(out) :: epsth(neps), depsth(neps)
    end subroutine mfront_varc
end interface
