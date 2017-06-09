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

subroutine apdmae(elem_code, elin_sub, elin_nbnode, elin_nbsub)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    character(len=8), intent(in) :: elem_code
    integer, intent(out) :: elin_sub(8,9)
    integer, intent(out) :: elin_nbnode(8)
    integer, intent(out) :: elin_nbsub
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
! SEG3  => 1xSEG3
! TRIA3 => 1xTRIA3
! TRIA6 => 1xTRIA6
! QUAD4 => 2xTRIA3
! QUAD8 => 6xTRIA3
! QUAD9 => 1xQUAD9
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_code        : code of current element
! Out elin_nbsub       : number of linearized sub-elements
! Out elin_nbnode      : number of nodes for each linearized sub-element
! Out elin_sub         : list of nodes for each linearized sub-element
!
! --------------------------------------------------------------------------------------------------
!
    elin_sub(:,:)  = 0
    elin_nbnode(:) = 0
    elin_nbsub     = 0
    if (elem_code .eq. 'SE2') then
        elin_nbsub     = 1
        elin_nbnode(1) = 2
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2    
    elseif (elem_code .eq. 'SE3') then
        elin_nbsub     = 1
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2 
        elin_sub(1,3)  = 3 
    elseif (elem_code .eq. 'TR3') then
        elin_nbsub     = 1
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2           
        elin_sub(1,3)  = 3       
    else if (elem_code .eq. 'TR6') then
        elin_nbsub     = 1
        elin_nbnode(1) = 6
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2          
        elin_sub(1,3)  = 3
        elin_sub(1,4)  = 4
        elin_sub(1,5)  = 5          
        elin_sub(1,6)  = 6
    else if (elem_code .eq. 'QU4' ) then
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
        elin_nbsub     = 6
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 5          
        elin_sub(1,3)  = 8
        elin_nbnode(2) = 3
        elin_sub(2,1)  = 5
        elin_sub(2,2)  = 2           
        elin_sub(2,3)  = 6
        elin_nbnode(3) = 3
        elin_sub(3,1)  = 6
        elin_sub(3,2)  = 3           
        elin_sub(3,3)  = 7
        elin_nbnode(4) = 3
        elin_sub(4,1)  = 7
        elin_sub(4,2)  = 4           
        elin_sub(4,3)  = 8
        elin_nbnode(5) = 3
        elin_sub(5,1)  = 5
        elin_sub(5,2)  = 6           
        elin_sub(5,3)  = 7
        elin_nbnode(6) = 3
        elin_sub(6,1)  = 7
        elin_sub(6,2)  = 8           
        elin_sub(6,3)  = 5
    else if (elem_code .eq. 'QU9') then
        elin_nbsub     = 1
        elin_nbnode(1) = 9
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2           
        elin_sub(1,3)  = 3
        elin_sub(1,4)  = 4
        elin_sub(1,5)  = 5           
        elin_sub(1,6)  = 6
        elin_sub(1,7)  = 7
        elin_sub(1,8)  = 8           
        elin_sub(1,9)  = 9
    else
        ASSERT(.false.)
    end if
!
end subroutine
