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
!
interface
    subroutine apcoor(jv_geom  , elem_type, elem_nume, elem_coor,&
                      elem_nbnode, elem_code, elem_dime, v_mesh_connex, v_connex_lcum)
        integer, intent(in) :: jv_geom
        character(len=8), intent(in) :: elem_type
        integer, intent(in) :: elem_nume
        real(kind=8), intent(out) :: elem_coor(27)
        integer, intent(out) :: elem_nbnode
        character(len=8), intent(out) :: elem_code
        integer, intent(out) :: elem_dime
        integer, pointer :: v_mesh_connex(:)
        integer, pointer :: v_connex_lcum(:)  
    end subroutine apcoor
end interface
