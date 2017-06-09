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
    subroutine rgndas(nume_ddlz, i_equa, l_print, type_equaz, name_nodez,&
                      name_cmpz, ligrelz)
        character(len=*), intent(in) :: nume_ddlz
        integer, intent(in) :: i_equa
        logical, intent(in) :: l_print
        character(len=1), optional, intent(out) :: type_equaz
        character(len=*), optional, intent(out) :: name_nodez
        character(len=*), optional, intent(out) :: name_cmpz
        character(len=*), optional, intent(out) :: ligrelz
    end subroutine rgndas
end interface
