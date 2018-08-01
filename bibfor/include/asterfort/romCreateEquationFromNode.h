! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine romCreateEquationFromNode(ds_empi, v_equa  , nume_dof    ,&
                                         grnode_, nb_node_, v_list_node_)
        use Rom_Datastructure_type
        type(ROM_DS_Empi), intent(in) :: ds_empi
        integer, pointer :: v_equa(:)
        character(len=24), intent(in) :: nume_dof
        character(len=24), optional, intent(in) :: grnode_
        integer, optional, intent(in) :: nb_node_
        integer, pointer, optional :: v_list_node_(:)
    end subroutine romCreateEquationFromNode
end interface
