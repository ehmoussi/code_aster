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
    subroutine matloc(mesh, connex_inv, keywordfact, iocc, node_nume, &
                      node_name, nb_repe_elem, list_repe_elem, matr_glob_loca)
        character(len=8), intent(in) :: mesh
        character(len=19), intent(in) :: connex_inv
        character(len=16), intent(in) :: keywordfact
        integer, intent(in) :: iocc
        character(len=8), intent(in) :: node_name
        integer, intent(in) :: node_nume
        integer, intent(in) :: nb_repe_elem
        integer, intent(in) :: list_repe_elem(*)
        real(kind=8), intent(out) :: matr_glob_loca(3, 3)
    end subroutine matloc
end interface
