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

subroutine apelem_getvertex(elem_dime, elem_code, l_linear ,&
                            para_coor, nb_vertex, para_code)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: elem_dime
    character(len=8), intent(in) :: elem_code
    aster_logical, intent(in) :: l_linear
    real(kind=8), intent(out) :: para_coor(elem_dime-1,4)
    integer, intent(out) :: nb_vertex
    character(len=8), intent(out) :: para_code
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get vertices of element in parametric space
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of current element
! In  elem_code        : code of current element
! In  l_linear         : .true. if get only linear vertices
! Out para_coor        : parametric coordinates for vertices of current element
! Out nb_vertex        : number of vertex (after linearization)
! Out para_code        : code of parametric element
!
! --------------------------------------------------------------------------------------------------
!
    if (l_linear) then
        if (elem_code .eq. 'SE2' .or.&
            elem_code .eq. 'SE3') then
            para_coor(1,1) = -1.d0
            para_coor(1,2) =  1.d0
            nb_vertex      = 2
            para_code      = 'SE2'
        elseif (elem_code .eq. 'TR3' .or.&
                elem_code .eq. 'TR6') then
            para_coor(1,1) = 0.d0
            para_coor(2,1) = 0.d0
            para_coor(1,2) = 1.d0
            para_coor(2,2) = 0.d0
            para_coor(1,3) = 0.d0
            para_coor(2,3) = 1.d0
            nb_vertex      = 3
            para_code      = 'TR3'
        else if (elem_code .eq. 'QU4' .or.&
                 elem_code .eq. 'QU8' .or.&
                 elem_code .eq. 'QU9') then
            para_coor(1,1) = -1.d0
            para_coor(2,1) = -1.d0
            para_coor(1,2) = +1.d0
            para_coor(2,2) = -1.d0
            para_coor(1,3) = +1.d0
            para_coor(2,3) = +1.d0
            para_coor(1,4) = -1.d0
            para_coor(2,4) = +1.d0
            nb_vertex      = 4
            para_code      = 'QU4'
        else
            ASSERT(.false.)
        end if
    else
        ASSERT(.false.)
    endif
!
end subroutine
