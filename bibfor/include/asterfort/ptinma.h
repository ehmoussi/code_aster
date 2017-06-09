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
    subroutine ptinma(elem_nbnode, elem_dime , elem_code, elem_coor, pair_tole,&
                      poin_coorx , poin_coory, test)
        integer, intent(in) :: elem_nbnode
        integer, intent(in) :: elem_dime
        character(len=8), intent(in) :: elem_code
        real(kind=8), intent(in) :: elem_coor(elem_dime-1,elem_nbnode)
        real(kind=8), intent(in) :: pair_tole
        real(kind=8), intent(in) :: poin_coorx
        real(kind=8), intent(in) :: poin_coory
        integer, intent(out) :: test
    end subroutine ptinma
end interface
