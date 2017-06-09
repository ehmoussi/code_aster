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
    subroutine mmform(ndim, nommae, nommam, nne, nnm,&
                      xpc, ypc, xpr, ypr, ffe,&
                      dffe, ddffe, ffm, dffm, ddffm,&
                      ffl, dffl, ddffl)
        integer :: ndim
        character(len=8) :: nommae
        character(len=8) :: nommam
        integer :: nne
        integer :: nnm
        real(kind=8) :: xpc
        real(kind=8) :: ypc
        real(kind=8) :: xpr
        real(kind=8) :: ypr
        real(kind=8) :: ffe(9)
        real(kind=8) :: dffe(2, 9)
        real(kind=8) :: ddffe(3, 9)
        real(kind=8) :: ffm(9)
        real(kind=8) :: dffm(2, 9)
        real(kind=8) :: ddffm(3, 9)
        real(kind=8) :: ffl(9)
        real(kind=8) :: dffl(2, 9)
        real(kind=8) :: ddffl(3, 9)
    end subroutine mmform
end interface
