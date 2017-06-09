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
    subroutine b3d_flu1d(vsigma, e0, dt, eps10, veps10,&
                         e1, eta1, eta2, veps20, deps0,&
                         deps1, deps2, veps1f, veps2f)
        real(kind=8) :: vsigma
        real(kind=8) :: e0
        real(kind=8) :: dt
        real(kind=8) :: eps10
        real(kind=8) :: veps10
        real(kind=8) :: e1
        real(kind=8) :: eta1
        real(kind=8) :: eta2
        real(kind=8) :: veps20
        real(kind=8) :: deps0
        real(kind=8) :: deps1
        real(kind=8) :: deps2
        real(kind=8) :: veps1f
        real(kind=8) :: veps2f
    end subroutine b3d_flu1d
end interface 
