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
    subroutine epsvmc(fami   , nno    , ndim  , nbsig, npg   ,&
                      j_poids, j_vf   , j_dfde, xyz  , disp  ,&
                      time   , repere, nharm, option,  epsi   )
        character(len=*), intent(in) :: fami
        integer, intent(in) :: nno
        integer, intent(in) :: ndim
        integer, intent(in) :: nbsig
        integer, intent(in) :: npg
        integer, intent(in) :: j_poids
        integer, intent(in) :: j_vf
        integer, intent(in) :: j_dfde
        real(kind=8), intent(in) :: xyz(1)
        real(kind=8), intent(in) :: disp(1)
        real(kind=8), intent(in) :: time
        real(kind=8), intent(in) :: repere(7)
        real(kind=8), intent(in) :: nharm
        character(len=16), intent(in) :: option
        real(kind=8), intent(out) :: epsi(1)
    end subroutine epsvmc
end interface
