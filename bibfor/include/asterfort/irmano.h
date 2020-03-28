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
    subroutine irmano(meshNameZ   , meshNbNode  ,&
                      nbCellSelect, cellSelect  ,&
                      nodeSelect  , nbNodeSelect,&
                      nodeFlag)
        character(len=*), intent(in) :: meshNameZ
        integer, intent(in) :: meshNbNode
        integer, intent(in) :: nbCellSelect
        integer, pointer :: cellSelect(:)
        integer, intent(inout) :: nbNodeSelect
        integer, pointer :: nodeSelect(:)
        integer, pointer :: nodeFlag(:)
    end subroutine irmano
end interface
