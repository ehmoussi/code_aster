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
    subroutine gdsig(fami, kpg, ksp, x0pg, petik,&
                     rot0, rotk, granc, imate, gn,&
                     gm, pn, pm)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        real(kind=8) :: x0pg(3)
        real(kind=8) :: petik(3)
        real(kind=8) :: rot0(3, 3)
        real(kind=8) :: rotk(3, 3)
        real(kind=8) :: granc(6)
        integer :: imate
        real(kind=8) :: gn(3)
        real(kind=8) :: gm(3)
        real(kind=8) :: pn(3)
        real(kind=8) :: pm(3)
    end subroutine gdsig
end interface
