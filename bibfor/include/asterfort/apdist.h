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
    subroutine apdist(elem_type, elem_coor, elem_nbnode, ksi1, ksi2,&
                      poin_coor, dist     , vect_pm)
        character(len=8), intent(in) :: elem_type
        real(kind=8), intent(in) :: elem_coor(27)
        integer, intent(in) :: elem_nbnode
        real(kind=8), intent(in) :: ksi1
        real(kind=8), intent(in) :: ksi2
        real(kind=8), intent(in) :: poin_coor(3)
        real(kind=8), intent(out) :: dist
        real(kind=8), intent(out) :: vect_pm(3)
    end subroutine apdist
end interface
