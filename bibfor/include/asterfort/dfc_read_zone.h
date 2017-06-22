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
    subroutine dfc_read_zone(sdcont      , keywf       , mesh        , model        ,nb_cont_zone,&
                             nb_cont_surf, nb_cont_elem, nb_cont_node)
        character(len=8), intent(in) :: sdcont
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: nb_cont_zone
        integer, intent(out) :: nb_cont_surf
        integer, intent(out) :: nb_cont_elem
        integer, intent(out) :: nb_cont_node
    end subroutine dfc_read_zone
end interface
