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
    subroutine distno(xlocal, signe, typeob, xjeu, dist1,&
                      dist2, dnorm, cost, sint)
        real(kind=8) :: xlocal(6)
        real(kind=8) :: signe(2)
        character(len=8) :: typeob
        real(kind=8) :: xjeu
        real(kind=8) :: dist1
        real(kind=8) :: dist2
        real(kind=8) :: dnorm
        real(kind=8) :: cost
        real(kind=8) :: sint
    end subroutine distno
end interface
