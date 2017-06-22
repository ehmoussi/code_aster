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
    subroutine fointe_varc(codmes   , fami        , kpg           , ksp           , poum,&
                           func_name, nb_para_user, para_name_user, para_vale_user,&
                           resu     , ier)
        character(len=*), intent(in) :: codmes
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        character(len=*), intent(in) :: poum
        character(len=*), intent(in) :: func_name
        integer, intent(in) :: nb_para_user
        character(len=*), intent(in) :: para_name_user(*)
        real(kind=8), intent(in) :: para_vale_user(*)
        real(kind=8), intent(out) :: resu
        integer, intent(out) :: ier
    end subroutine fointe_varc
end interface
