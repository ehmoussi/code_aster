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
    subroutine romBaseComponents(mesh          , nb_equa    ,&
                                 field_name    , field_refe ,&
                                 nb_cmp_by_node, cmp_by_node, l_lagr)
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: nb_equa
        character(len=16), intent(in) :: field_name
        character(len=24), intent(in) :: field_refe
        integer, intent(out) :: nb_cmp_by_node
        character(len=8), intent(out)  :: cmp_by_node(10)
        aster_logical, intent(out) :: l_lagr
    end subroutine romBaseComponents
end interface
