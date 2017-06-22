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
    subroutine gtclno(jv_geom, list_node, nb_node, testnode ,nume_node_cl)
        integer, intent(in) :: jv_geom
        integer, pointer, intent(in) :: list_node(:)
        integer, intent(in) :: nb_node
        real(kind=8), intent(in) :: testnode(3)
        integer, intent(out) :: nume_node_cl
    end subroutine gtclno
end interface
