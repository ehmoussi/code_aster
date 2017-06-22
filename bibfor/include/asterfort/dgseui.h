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
    subroutine dgseui(em, num, ef, nuf, eb,&
                      nub, sytb, h, icisai, syt,&
                      syc, dxd, syf, drd, pelast,&
                      pelasf, icompr)
        real(kind=8) :: em
        real(kind=8) :: num
        real(kind=8) :: ef
        real(kind=8) :: nuf
        real(kind=8) :: eb
        real(kind=8) :: nub
        real(kind=8) :: sytb
        real(kind=8) :: h
        integer :: icisai
        real(kind=8) :: syt
        real(kind=8) :: syc
        real(kind=8) :: dxd
        real(kind=8) :: syf
        real(kind=8) :: drd
        real(kind=8) :: pelast
        real(kind=8) :: pelasf
        integer :: icompr
    end subroutine dgseui
end interface
