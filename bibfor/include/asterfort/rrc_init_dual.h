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
interface
    subroutine rrc_init_dual(mesh       , result_rom , field_name,&
                             nb_equa_dom, mode_empi  , grnode_int,&
                             v_equa_rid , nb_equa_rom,&
                             v_equa_int , nb_equa_int)
        character(len=8), intent(in) :: mesh, result_rom
        character(len=24), intent(in) :: field_name, mode_empi
        integer, intent(in) :: nb_equa_dom
        character(len=24), intent(in) :: grnode_int
        integer, pointer :: v_equa_rid(:)
        integer, intent(out) :: nb_equa_rom
        integer, pointer :: v_equa_int(:)
        integer, intent(out) :: nb_equa_int
    end subroutine rrc_init_dual
end interface
