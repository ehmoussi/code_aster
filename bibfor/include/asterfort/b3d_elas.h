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
    subroutine b3d_elas(var0, nvari, nvar0, depsv, dgamd6,&
                        xk0, xmu0, sigef6, varf, hydra0,&
                        hydra1)
        integer :: nvari
        real(kind=8) :: var0(nvari)
        integer :: nvar0
        real(kind=8) :: depsv
        real(kind=8) :: dgamd6(6)
        real(kind=8) :: xk0
        real(kind=8) :: xmu0
        real(kind=8) :: sigef6(6)
        real(kind=8) :: varf(nvari)
        real(kind=8) :: hydra0
        real(kind=8) :: hydra1
    end subroutine b3d_elas
end interface 
