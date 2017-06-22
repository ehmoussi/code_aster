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
interface 
    subroutine b3d_actherm(teta1, eafluage, xmg0, xmw0, taug0,&
                           etag1, etaw1)
        real(kind=8) :: teta1
        real(kind=8) :: eafluage
        real(kind=8) :: xmg0
        real(kind=8) :: xmw0
        real(kind=8) :: taug0
        real(kind=8) :: etag1
        real(kind=8) :: etaw1
    end subroutine b3d_actherm
end interface 
