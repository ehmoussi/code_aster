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
interface
    subroutine mmnewt(type_elem, nb_node  , nb_dim, elem_coor, pt_coor,&
                      iter_maxi, tole_maxi, ksi1  , ksi2     , tang_1 ,&
                      tang_2   , error, l_reli_)
        character(len=8), intent(in) :: type_elem
        integer, intent(in) :: nb_node
        integer, intent(in) :: nb_dim
        real(kind=8), intent(in) :: elem_coor(27)
        real(kind=8), intent(in) :: pt_coor(3)
        integer, intent(in) :: iter_maxi
        real(kind=8), intent(in) :: tole_maxi
        real(kind=8), intent(out) :: ksi1
        real(kind=8), intent(out) :: ksi2
        real(kind=8), intent(out) :: tang_1(3)
        real(kind=8), intent(out) :: tang_2(3)
        integer, intent(out) :: error
        aster_logical, intent(in), optional:: l_reli_
    end subroutine mmnewt
end interface
