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
    subroutine trprot(model, bamo, tgeom, imodg, iadx,&
                      iady, iadz, isst, iadrp, norm1,&
                      norm2, ndble, num, nu, ma,&
                      mate, moint, ilires, k, icor)
        character(len=2) :: model
        character(len=8) :: bamo
        real(kind=8) :: tgeom(6)
        integer :: imodg
        integer :: iadx
        integer :: iady
        integer :: iadz
        integer :: isst
        integer :: iadrp
        real(kind=8) :: norm1
        real(kind=8) :: norm2
        integer :: ndble
        character(len=14) :: num
        character(len=14) :: nu
        character(len=8) :: ma
        character(len=*) :: mate
        character(len=8) :: moint
        integer :: ilires
        integer :: k
        integer :: icor(2)
    end subroutine trprot
end interface
