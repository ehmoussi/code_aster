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
    subroutine xrelco(mesh   , model, nb_dim, sdline_crack, nb_rela_line, list_rela_line,&
                      nb_edge)
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        integer, intent(in) :: nb_dim
        character(len=14), intent(in) :: sdline_crack
        character(len=19), intent(in) :: list_rela_line
        integer, intent(out) :: nb_rela_line
        integer, intent(out) :: nb_edge
    end subroutine xrelco
end interface
