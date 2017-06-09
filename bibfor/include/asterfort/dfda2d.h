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
    subroutine dfda2d(kpg, nno, poids, sdfrde, sdfrdk,&
                      sdedx, sdedy, sdkdx, sdkdy, sdfdx,&
                      sdfdy, geom, jac)
        integer :: kpg
        integer :: nno
        real(kind=8) :: poids
        real(kind=8) :: sdfrde(4, 4)
        real(kind=8) :: sdfrdk(4, 4)
        real(kind=8) :: sdedx(4)
        real(kind=8) :: sdedy(4)
        real(kind=8) :: sdkdx(4)
        real(kind=8) :: sdkdy(4)
        real(kind=8) :: sdfdx(4, 4)
        real(kind=8) :: sdfdy(4, 4)
        real(kind=8) :: geom(2, 4)
        real(kind=8) :: jac
    end subroutine dfda2d
end interface
