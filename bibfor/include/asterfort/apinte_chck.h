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
    subroutine apinte_chck(proj_tole       , elem_dime     , &
                           elem_mast_nbnode, elem_mast_coor, &
                           elem_slav_nbnode, elem_slav_coor, elem_slav_code,&
                           proj_coor       , mast_norm     , slav_norm     ,&
                           l_inter)
        real(kind=8), intent(in) :: proj_tole
        integer, intent(in) :: elem_dime
        integer, intent(in) :: elem_mast_nbnode
        real(kind=8), intent(in) :: elem_mast_coor(3,9)
        integer, intent(in) :: elem_slav_nbnode
        real(kind=8), intent(in) :: elem_slav_coor(3,9)
        character(len=8), intent(in) :: elem_slav_code
        real(kind=8), intent(in) :: proj_coor(elem_dime-1,4)
        real(kind=8), intent(in) :: mast_norm(3), slav_norm(3)
        aster_logical, intent(out) :: l_inter
    end subroutine apinte_chck
end interface
