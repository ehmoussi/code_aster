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
    subroutine btdmsr(nb1, nb2, ksi3s2, intsr, xr,&
                      epais, vectpt, hsj1m, hsj1s, btdm,&
                      btds)
        integer :: nb1
        integer :: nb2
        real(kind=8) :: ksi3s2
        integer :: intsr
        real(kind=8) :: xr(*)
        real(kind=8) :: epais
        real(kind=8) :: vectpt(9, 2, 3)
        real(kind=8) :: hsj1m(3, 9)
        real(kind=8) :: hsj1s(2, 9)
        real(kind=8) :: btdm(4, 3, 42)
        real(kind=8) :: btds(4, 2, 42)
    end subroutine btdmsr
end interface
