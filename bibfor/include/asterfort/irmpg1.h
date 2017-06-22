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
    subroutine irmpg1(nofimd, nomfpg, nbnoto, nbrepg, nbsp,&
                      ndim, typgeo, refcoo, gscoo, wg,&
                      raux1, raux2, raux3, nolopg, nomasu,&
                      codret)
        character(len=*) :: nofimd
        character(len=16) :: nomfpg
        integer :: nbnoto
        integer :: nbrepg
        integer :: nbsp
        integer :: ndim
        integer :: typgeo
        real(kind=8) :: refcoo(*)
        real(kind=8) :: gscoo(*)
        real(kind=8) :: wg(*)
        real(kind=8) :: raux1(*)
        real(kind=8) :: raux2(*)
        real(kind=8) :: raux3(*)
        character(len=*) :: nolopg
        character(len=*) :: nomasu
        integer :: codret
    end subroutine irmpg1
end interface
