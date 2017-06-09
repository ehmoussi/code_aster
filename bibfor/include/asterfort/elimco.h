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
#include "asterf_types.h"
!
interface
    subroutine elimco(sdcont      , mesh        , model       , nb_cont_surf,&
                      nb_cont_elem, nb_cont_node, l_elim_coq3d, nb_node_coq3d_)
        character(len=8), intent(in) :: sdcont
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        integer, intent(in) :: nb_cont_surf
        integer, intent(inout) :: nb_cont_elem
        integer, intent(inout) :: nb_cont_node
        aster_logical, intent(in) :: l_elim_coq3d
        integer, optional, intent(out) :: nb_node_coq3d_
    end subroutine elimco
end interface
