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
    subroutine testvois(jv_geom       , elem_slav_type,&
                        elem_mast_coor, elem_mast_code, elem_slav_nume,&
                        pair_tole     , inte_weight,    v_mesh_connex,&
                        v_connex_lcum)
        integer, intent(in) :: jv_geom
        character(len=8), intent(in) :: elem_slav_type
        real(kind=8),intent(in) :: elem_mast_coor(27)
        character(len=8),intent(in) :: elem_mast_code
        integer,intent(in) :: elem_slav_nume
        real(kind=8),intent(in) :: pair_tole
        real(kind=8),intent(out) :: inte_weight
        integer, pointer, intent(in) :: v_mesh_connex(:)
        integer, pointer, intent(in) :: v_connex_lcum(:)      
   end subroutine testvois
end interface
