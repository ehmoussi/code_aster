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

subroutine apdcma(elem_code, elin_sub, elin_nbnode, elin_nbsub, elin_code)
!
implicit none
!
#include "asterfort/assert.h"
!
character(len=8), intent(in) :: elem_code
integer, intent(out) :: elin_sub(2,3)
integer, intent(out) :: elin_nbnode(2)
integer, intent(out) :: elin_nbsub
character(len=8), intent(out) :: elin_code
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Cut element in linearized sub-elements (SEG2 or TRIA3)
!
! --------------------------------------------------------------------------------------------------
!
! SEG2  => 1xSEG2
! SEG3  => 2xSEG2
! TRIA3 => 1xTRIA3
! TRIA6 => 4xTRIA3
! QUAD4 => 2xTRIA3
! QUAD8 => 6xTRIA3
! QUAD9 => 2xTRIA3
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_code        : code of current element
! Out elin_nbsub       : number of linearized sub-elements
! Out elin_nbnode      : number of nodes for each linearized sub-element
! Out elin_sub         : list of nodes for each linearized sub-element
! Out elin_code        : code of linearized sub-element (SE2 or TR3)
!
! --------------------------------------------------------------------------------------------------
!
    elin_sub(:,:)    = 0
    elin_nbnode(:)   = 0
    elin_nbsub       = 0
    if (elem_code .eq. 'SE2'.or. elem_code .eq. 'SE3') then
        elin_nbsub     = 1
        elin_nbnode(1) = 2
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2
        elin_code      = 'SE2'
    elseif (elem_code .eq. 'TR3' .or. elem_code .eq. 'TR6') then
        elin_nbsub     = 1
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2
        elin_sub(1,3)  = 3
        elin_code      = 'TR3'
    else if (elem_code .eq. 'QU4' .or. elem_code .eq. 'QU8' .or.&
             elem_code .eq. 'QU9') then
        elin_nbsub     = 2
        elin_nbnode(1) = 3
        elin_sub(1,1)  = 1
        elin_sub(1,2)  = 2
        elin_sub(1,3)  = 3
        elin_nbnode(2) = 3
        elin_sub(2,1)  = 3
        elin_sub(2,2)  = 4
        elin_sub(2,3)  = 1
        elin_code      = 'TR3'
    else
        ASSERT(ASTER_FALSE)
    end if
!
end subroutine
