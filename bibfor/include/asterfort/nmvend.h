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
    subroutine nmvend(fami, kpg, ksp, materd, materf,&
                      nmat, dt1, deps, sigm,&
                      vim, ndim, crit, dammax, etatf,&
                      p, np, beta, nb, iter,&
                      ier)
        integer :: nb
        integer :: np
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        real(kind=8) :: materd(nmat, 2)
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: dt1
        real(kind=8) :: deps(6)
        real(kind=8) :: sigm(6)
        real(kind=8) :: vim(*)
        integer :: ndim
        real(kind=8) :: crit(*)
        real(kind=8) :: dammax
        character(len=7) :: etatf(3)
        real(kind=8) :: p(np)
        real(kind=8) :: beta(nb)
        integer :: iter
        integer :: ier
    end subroutine nmvend
end interface
