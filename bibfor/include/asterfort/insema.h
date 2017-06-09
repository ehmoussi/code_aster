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
    subroutine insema(elem_nbnode , elem_dime, elem_coor , pair_tole,&
                      xp1         , yp1      , xp2       , yp2      ,&
                      nb_poin_inte, poin_inte, inte_neigh_)
        integer, intent(in) :: elem_nbnode
        integer, intent(in) :: elem_dime
        real(kind=8), intent(in) :: elem_coor(2,elem_nbnode)
        real(kind=8) :: pair_tole
        real(kind=8), intent(in) :: xp1
        real(kind=8), intent(in) :: yp1
        real(kind=8), intent(in) :: xp2
        real(kind=8), intent(in) :: yp2
        integer, intent(inout) :: nb_poin_inte
        real(kind=8), intent(inout) :: poin_inte(elem_dime-1,16)
        integer, optional, intent(inout) :: inte_neigh_(4)
    end subroutine insema
end interface
