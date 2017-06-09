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
    subroutine lcrtma(elem_dime       , proj_tole,&
                      tria_coor       , &
                      elin_slav_nbnode, elin_slav_coor, elin_slav_code,&
                      elem_mast_nbnode, elem_mast_coor, elem_mast_code,&
                      tria_coot)
        integer, intent(in) :: elem_dime
        real(kind=8), intent(in) :: proj_tole
        real(kind=8), intent(in) :: tria_coor(elem_dime-1,3)
        integer, intent(in) :: elin_slav_nbnode
        real(kind=8), intent(in) :: elin_slav_coor(elem_dime,elin_slav_nbnode)
        character(len=8), intent(in) :: elin_slav_code
        integer, intent(in) :: elem_mast_nbnode
        real(kind=8), intent(in) :: elem_mast_coor(elem_dime,elem_mast_nbnode)
        character(len=8), intent(in) :: elem_mast_code
        real(kind=8), intent(out) :: tria_coot(2,3)
    end subroutine lcrtma
end interface
