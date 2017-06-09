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
    subroutine pipeou(mat, sup, sud, mup, mud,&
                      vim, tau, copilo)
        integer :: mat
        real(kind=8) :: sup(3)
        real(kind=8) :: sud(3)
        real(kind=8) :: mup(3)
        real(kind=8) :: mud(3)
        real(kind=8) :: vim(*)
        real(kind=8) :: tau
        real(kind=8) :: copilo(5)
    end subroutine pipeou
end interface
