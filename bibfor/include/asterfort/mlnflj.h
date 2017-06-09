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
    subroutine mlnflj(nb, n, ll, m, it,&
                      p, frontl, frontu, frnl, frnu,&
                      adper, travl, travu, cl, cu)
        integer :: p
        integer :: nb
        integer :: n
        integer :: ll
        integer :: m
        integer :: it
        real(kind=8) :: frontl(*)
        real(kind=8) :: frontu(*)
        real(kind=8) :: frnl(*)
        real(kind=8) :: frnu(*)
        integer :: adper(*)
        real(kind=8) :: travl(p, nb, *)
        real(kind=8) :: travu(p, nb, *)
        real(kind=8) :: cl(nb, nb, *)
        real(kind=8) :: cu(nb, nb, *)
    end subroutine mlnflj
end interface
