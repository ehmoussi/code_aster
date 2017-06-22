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
    subroutine solide_tran(type_geo, noma, type_vale, dist_mini, nb_node, list_node, &
                           type_lagr, lisrel, nom_noeuds, dim)
        character(len=2), intent(in)  :: type_geo
        character(len=8), intent(in)  :: noma
        character(len=4), intent(in)  :: type_vale
        real(kind=8), intent(in)      :: dist_mini
        integer, intent(in)           :: nb_node
        character(len=24), intent(in) :: list_node
        character(len=2), intent(in)  :: type_lagr
        character(len=19), intent(in) :: lisrel
        character(len=8), intent(out) :: nom_noeuds(:)
        integer, intent(out)          :: dim
    end subroutine solide_tran
end interface
