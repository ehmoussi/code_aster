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
    subroutine prjint(pair_tole     , elem_dime       ,&
                      elin_slav_coor, elin_slav_nbnode, elin_slav_code,&
                      elin_mast_coor, elin_mast_nbnode, elin_mast_code,&
                      poin_inte     , inte_weight     , nb_poin_inte  ,&
                      inte_neigh_)
        real(kind=8), intent(in) :: pair_tole
        integer, intent(in) :: elem_dime
        real(kind=8), intent(in) :: elin_slav_coor(3,9)
        integer, intent(in) :: elin_slav_nbnode
        character(len=8), intent(in) :: elin_slav_code
        real(kind=8), intent(in) :: elin_mast_coor(3,9)
        integer, intent(in) :: elin_mast_nbnode
        character(len=8), intent(in) :: elin_mast_code
        real(kind=8), intent(out) :: poin_inte(elem_dime-1,16)
        real(kind=8), intent(out) :: inte_weight
        integer, intent(out) :: nb_poin_inte
        integer, optional, intent(inout) :: inte_neigh_(4)
    end subroutine prjint
end interface
