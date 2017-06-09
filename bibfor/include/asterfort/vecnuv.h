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
    subroutine vecnuv(ipre, ider, gamma, phinit, dphi,&
                      n, k, dim, vectn, vectu,&
                      vectv)
        integer :: dim
        integer :: ipre
        integer :: ider
        real(kind=8) :: gamma
        real(kind=8) :: phinit
        real(kind=8) :: dphi
        integer :: n
        integer :: k
        real(kind=8) :: vectn(dim)
        real(kind=8) :: vectu(dim)
        real(kind=8) :: vectv(dim)
    end subroutine vecnuv
end interface
