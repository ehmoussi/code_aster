! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
interface
    subroutine romFieldNodesAreDefined(field  , listEqua, numeDof  ,&
                                       grnode_, nbNode_ , listNode_)
        use Rom_Datastructure_type
        type(ROM_DS_Field), intent(in) :: field
        integer, pointer :: listEqua(:)
        character(len=24), intent(in) :: numeDof
        character(len=24), optional, intent(in) :: grnode_
        integer, optional, intent(in) :: nbNode_
        integer, pointer, optional :: listNode_(:)
    end subroutine romFieldNodesAreDefined
end interface
