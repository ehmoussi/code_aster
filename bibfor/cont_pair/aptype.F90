! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine aptype(elem_type  ,&
                  elem_nbnode, elem_code, elem_dime)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
character(len=8), intent(in) :: elem_type
integer, intent(out) :: elem_nbnode
character(len=8), intent(out) :: elem_code
integer, intent(out) :: elem_dime
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get informations about element
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_type        : geometric type of element
! Out elem_nbnode      : number of node for current element
! Out elem_code        : code of current element
! Out elem_dime        : dimension of current element
!
! --------------------------------------------------------------------------------------------------
!
    select case (elem_type)
        case('SEG2')
            elem_code   = 'SE2'
            elem_nbnode = 2
            elem_dime   = 2
        case('SEG3')
            elem_code   = 'SE3'
            elem_nbnode = 3
            elem_dime   = 2
        case('TRIA3')
            elem_code   = 'TR3'
            elem_nbnode = 3
            elem_dime   = 3
        case('TRIA6')
            elem_code   = 'TR6'
            elem_nbnode = 6
            elem_dime   = 3
        case('QUAD4')
            elem_code   = 'QU4'
            elem_nbnode = 4
            elem_dime   = 3
        case('QUAD8')
            elem_code   = 'QU8'
            elem_nbnode = 8
            elem_dime   = 3
        case('QUAD9')
            elem_code   = 'QU9'
            elem_nbnode = 9
            elem_dime   = 3
        case default
            ASSERT(ASTER_FALSE)
    end select
!
end subroutine
