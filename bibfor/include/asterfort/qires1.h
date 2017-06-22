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
    subroutine qires1(modele, ligrel, chtime, sigmap, sigmad,&
                      lcharp, lchard, ncharp, nchard, chs,&
                      mate, chvois, tabido, chelem)
        character(len=8) :: modele
        character(len=*) :: ligrel
        character(len=24) :: chtime
        character(len=24) :: sigmap
        character(len=24) :: sigmad
        character(len=8) :: lcharp(1)
        character(len=8) :: lchard(1)
        integer :: ncharp
        integer :: nchard
        character(len=24) :: chs
        character(len=*) :: mate
        character(len=24) :: chvois
        integer :: tabido(5)
        character(len=24) :: chelem
    end subroutine qires1
end interface
