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
    subroutine nmext2(mesh         , field    , nb_cmp  , nb_node  , type_extr,&
                      type_extr_cmp, list_node, list_cmp, work_node)
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: nb_node
        integer, intent(in) :: nb_cmp
        character(len=8), intent(in) :: type_extr
        character(len=8), intent(in) :: type_extr_cmp
        character(len=24), intent(in) :: list_node
        character(len=24), intent(in) :: list_cmp
        character(len=19), intent(in) :: field
        character(len=19), intent(in) :: work_node
    end subroutine nmext2
end interface
