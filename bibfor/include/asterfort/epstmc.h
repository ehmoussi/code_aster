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
    subroutine epstmc(fami     , ndim  , instan, poum   , kpg   ,&
                      ksp      , xyzgau, repere, j_mater, option,&
                      epsi_varc)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: ndim
        character(len=*), intent(in) :: poum
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer, intent(in) :: j_mater
        real(kind=8), intent(in) :: xyzgau(3)
        real(kind=8), intent(in) :: repere(7)
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: instan
        real(kind=8), intent(out) :: epsi_varc(6)
    end subroutine epstmc
end interface
