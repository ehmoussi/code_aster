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

subroutine dctest(elem_code, elin_sub, elin_nbnode, elin_nbsub, elin_code)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    character(len=8), intent(in) :: elem_code
    integer, intent(out) :: elin_sub(8,4)
    integer, intent(out) :: elin_nbnode(8)
    integer, intent(out) :: elin_nbsub
    character(len=8),intent(out) :: elin_code
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Cut element in linearized sub-elements
!
! --------------------------------------------------------------------------------------------------
!
! SEG2  => 1xSEG2
! SEG3  => 1xSEG2
! TRIA3 => 1xTRIA3
! TRIA6 => 1xTRIA3
! QUAD4 => 2xTRIA3
! QUAD8 => 2xTRIA3
! QUAD9 => 2xTRIA3
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_code        : code of current element
! Out elin_nbsub       : number of linearized sub-elements
! Out elin_nbnode      : number of nodes for each linearized sub-element
! Out elin_sub         : list of nodes for each linearized sub-element
! Out elin_code        : code of of each linearized sub-element
!
! --------------------------------------------------------------------------------------------------
!
    if (elem_code .eq. 'SE2') then
        elin_code      = 'SE2'
        elin_nbsub     = 1
        elin_nbnode(1) = 2
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2 
    elseif (elem_code .eq. 'SE3') then
        elin_code      = 'SE2'
        elin_nbsub     = 1
        elin_nbnode(1) = 2
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2 
    elseif (elem_code .eq. 'TR3') then
        elin_code      = 'TR3'
        elin_nbsub     = 1
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2           
        elin_sub(1,3)  = 3       
    else if (elem_code .eq. 'TR6') then
        elin_code      = 'TR3'
        elin_nbsub     = 1
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2           
        elin_sub(1,3)  = 3
    else if (elem_code .eq. 'QU4') then
        elin_code      = 'TR3'
        elin_nbsub     = 2
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2           
        elin_sub(1,3)  = 3
        elin_nbnode(2) = 3
        elin_sub(2,1)  = 3
        elin_sub(2,2)  = 4           
        elin_sub(2,3)  = 1
    else if (elem_code .eq. 'QU8') then
        elin_code      = 'TR3'
        elin_nbsub     = 2
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2           
        elin_sub(1,3)  = 3
        elin_nbnode(2) = 3
        elin_sub(2,1)  = 3
        elin_sub(2,2)  = 4           
        elin_sub(2,3)  = 1
    else if (elem_code .eq. 'QU9') then
        elin_code      = 'TR3'
        elin_nbsub     = 2
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2           
        elin_sub(1,3)  = 3
        elin_nbnode(2) = 3
        elin_sub(2,1)  = 3
        elin_sub(2,2)  = 4           
        elin_sub(2,3)  = 1
    else
        ASSERT(.false.)
    end if
!
end subroutine
