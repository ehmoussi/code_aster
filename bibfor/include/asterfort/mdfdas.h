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
    subroutine mdfdas(dnorm, vnorm, vitloc, cost, sint,&
                      coefk1, coefk2, coefpy, coefc, coefad,&
                      xmax, fdispo, flocal)
        real(kind=8) :: dnorm
        real(kind=8) :: vnorm
        real(kind=8) :: vitloc(3)
        real(kind=8) :: cost
        real(kind=8) :: sint
        real(kind=8) :: coefk1
        real(kind=8) :: coefk2
        real(kind=8) :: coefpy
        real(kind=8) :: coefc
        real(kind=8) :: coefad
        real(kind=8) :: xmax
        real(kind=8) :: fdispo
        real(kind=8) :: flocal(3)
    end subroutine mdfdas
end interface
